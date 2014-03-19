module Shipping
  module Buyer
    class OrdersController < ApplicationController

      skip_before_filter :verify_authenticity_token, only: [:notify_url_from_alipay]
      before_filter :authenticate_user!, except: [:notify_url_from_alipay]

      before_action :set_items, only: [:pre_create, :save_order]
      before_action :set_order, only: [:confirm, :open_payment_page, :cal_order_total_price_ajax]

      TAOBAO_RETURN_URL_DEVELOPMENT = 'http://localhost:3000/shipping/buyer/orders/complete_payment_from_alipay'
      TAOBAO_RETURN_URL_PRODUCTION = 'http://www.superhaitao.com/shipping/buyer/orders/complete_payment_from_alipay'
      TAOBAO_NOTIFY_URL_DEVELOPMENT = 'http://192.241.180.75:3000/shipping/buyer/orders/notify_url_from_alipay'
      TAOBAO_NOTIFY_URL_PRODUCTION = 'http://www.superhaitao.com/shipping/buyer/orders/notify_url_from_alipay'

      def index
        @orders = Order.includes(:items).where(user_id: current_user.id)
                        .order('created_at desc').paginate(:page => params[:page], :per_page => 10)
      end

      def show
        @order = Order.find(params[:id])
      end

      def pre_create
        @order = Order.new
      end

      def create
        if params[:item_list]
          if Item.select('sum(weight) as sum_weight').where(id: params[:item_list]).first['sum_weight'] > 30
            flash[:alert] = '所选货品的最大重量不能超过30KG!'
            redirect_to shipping_buyer_items_path
          else
            redirect_to action: :pre_create, :item_list => params[:item_list]
          end
        else
          flash[:alert] = t('message.order.item_is_not_null')
          redirect_to shipping_buyer_items_path
        end
      end

      def save_order
        respond_to do |format|
          begin
            Order.transaction do
              order = Order.create!(user_id: current_user.id)
              @items.each do |item|
                item.change_state_created_order
                item.order = order
                item.save!
              end
              format.html { redirect_to action: 'confirm', id: order.id }
            end
          rescue Exception => errors
            flash[:alert] = t('message.order.create_order_error')
            format.html { redirect_to action: :pre_create, item_list: params[:item_list] }
          end
        end
      end

      def confirm
        @show_receivers = Receiver.includes(:district, :city, :province)
                                  .where(:active => true, :user_id => current_user.id).limit(5)
                                  .order('selected_at desc')
      end

      def fix_order
        @order = Order.find(params[:order][:id])
        respond_to do |format|
          if params[:order][:receiver_id]
            begin
              receiver = Receiver.find(params[:order][:receiver_id])
              @order.receiver_message =receiver.show_receiver_message
              @order.receiver = receiver
              receiver.selected_at = DateTime.now
              @order.create_value_added_services(params[:chk_firm_package], params[:txt_balloon])
              receiver.save!
              @order.save!
              format.html { redirect_to action: :open_payment_page, id: @order.id }
            rescue Exception => errors
              flash[:alert] = t('message.order.create_order_error')
              format.html { redirect_to action: :confirm, id: @order.id }
            end
          else
            flash[:alert] = t('message.order.should_have_receiver')
            format.html { redirect_to action: :confirm, id: @order.id }
          end

        end
      end

      def open_payment_page
        @price = Price.by_weight(@order.get_items_weight)
      end

      def payment
        @order = Order.find(params[:order][:id])
        total_price = Price.by_weight(@order.get_items_weight)
        trade_point = BigDecimal.new(params[:trade_point] || 0)
        @order.trade_point = trade_point
        @order.save

        if (total_price - trade_point) <= 0
          begin
            user_id = current_user.id
            @order.change_state_pending_audit(total_price, trade_point)
            current_user = User.find(user_id)
            @status = 'payment success'
            render template: 'shipping/buyer/orders/complete_payment'
          rescue Exception => errors
            flash[:alert] = t('message.order.payment_error')
            redirect_to action: :open_payment_page, id: @order.id
          end
        else
          payment_by_alipay(total_price - trade_point, @order)
        end
      end

      def complete_payment_from_alipay
        @status = ''
        @order = Order.where(number: params[:out_trade_no].split('_')[0],
                             user_id: params[:out_trade_no].split('_')[1]).first
        if params[:is_success] == 'T' && params[:trade_status] == 'WAIT_SELLER_SEND_GOODS'
          save_order_and_user_by_alipay(params)
        else
          @status = 'payment failed'
        end

        render 'shipping/buyer/orders/complete_payment'
      end

      def destroy
        order = Order.find(params[:id])
        if order.state == 'unpaid'
          begin
            Order.transaction do
              order.change_state_cancel
              flash[:notice] = '订单取消成功！'
            end
          rescue Exception => errors
            flash[:alert] = '订单取消失败，请重新操作！'
          end
        else
          flash[:alert] = '订单已开始处理，无法取消！'
        end
        respond_to do |format|
          format.html { redirect_to shipping_buyer_orders_path }
        end
      end

      def notify_url_from_alipay
        notify_params = params.except(*request.path_parameters.keys)
        if Alipay::Notify.verify?(notify_params)
          if params[:trade_status] == 'WAIT_SELLER_SEND_GOODS'
            @status = ''
            @order = Order.where(number: params[:out_trade_no].split('_')[0],
                                 user_id: params[:out_trade_no].split('_')[1]).first
            if @order.trade_no == nil || @order.trade_no == ''
              save_order_and_user_by_alipay(params)
              if @status == 'payment success'
                render text: 'success'
              else
                render text: 'fail'
              end
            else
              render text: 'success'
            end
          end
        else
          render text: 'fail'
        end
      end

      def cal_order_total_price_ajax
        is_firm_package = params[:is_firm_package]
        balloon_num = params[:balloon_num]
        render text: cal_order_total_price(is_firm_package, balloon_num)
      end

      private
      def set_items
        @items = Item.where(id: params[:item_list], user_id: current_user.id)
      end

      def set_order
        @order = nil
        orders = Order.where(id: params[:id], user_id: current_user.id)
        if orders
          @order = orders.first
        end
      end

      def cal_order_total_price(is_firm_package, balloon_num)
        total_price = 0.0
        total_price += Price.by_weight(@order.get_items_weight)
        total_price += @order.cal_warehouse_charges
        unless is_firm_package.empty?
          total_price += @order.cal_firm_package_charges
        end
        total_price += balloon_num.to_i * 5
        total_price
      end

      def order_params
        params.require(:order).permit(:id, :number, :state, :total_price, :user_id, :receiver_message,
                                      :receiver_id, :selected_at, :international_waybill_no,
                                      :international_waybill_company, :trade_point)
      end

      def save_order_and_user_by_alipay(params)
        @order.trade_no = params[:trade_no]
        @order.gmt_create = params[:gmt_create]
        @order.gmt_payment = params[:gmt_payment]
        total_price = Price.by_weight(@order.get_items_weight)
        begin
          user_id = current_user.id if current_user
          @order.change_state_pending_audit(total_price, @order.trade_point)
          current_user = User.find(user_id) if current_user
          @status = 'payment success'
        rescue Exception => errors
          @status = 'save failed'
        end
      end

      def payment_by_alipay(price, order)
        return_url = TAOBAO_RETURN_URL_DEVELOPMENT
        return_url = TAOBAO_RETURN_URL_PRODUCTION if Rails.env.production?
        notify_url = TAOBAO_NOTIFY_URL_DEVELOPMENT
        notify_url = TAOBAO_NOTIFY_URL_PRODUCTION if Rails.env.production?

        options = {
            out_trade_no: order.number + '_' + current_user.id.to_s + '_S',
            subject: order.number,
            logistics_type: 'EXPRESS',
            logistics_fee: '0',
            logistics_payment: 'SELLER_PAY',
            price: price,
            quantity: 1,
            discount: 0,
            return_url: return_url,
            notify_url: notify_url,
            receive_name: order.receiver.name,
            receive_address: order.receiver.address,
            receive_zip: order.receiver.zip_code,
            receive_phone: order.receiver.phone
        }
        begin
          redirect_to Alipay::Service.create_partner_trade_by_buyer_url(options)
        rescue Exception => errors
          flash[:alert] = t('message.order.payment_error')
          redirect_to action: :open_payment_page, id: order.id
        end
      end

      def send_items_by_alipay(order)
        options = {
            :trade_no => order.trade_no,
            :logistics_name => 'Superhaitao',
            :transport_type => 'EXPRESS'
        }
        xml = Alipay::Service.send_goods_confirm_by_platform(options)
        doc = REXML::Document.new xml
        REXML::XPath.first(doc, '//is_success').text
      end

    end
  end
end