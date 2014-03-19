module Shipping
  module Admin
    class OrdersController < AdminController

      def index
        if params[:q] != nil
          @search_number_cont = params[:q][:number_cont]
          @search_state_eq = params[:q][:state_eq]
          @search_user_name_cont = params[:q][:user_name_cont]
        end

        @search = Order.search(params[:q])
        @orders = @search.result.includes(:user).order('created_at desc')
                                .paginate(:page => params[:page], :per_page => 15)
      end

      def show
        @order = Order.find(params[:id])
      end

      def show_checked_order
        @order = Order.find(params[:id])
      end

      def checked_order
        order = Order.find(params[:order][:id])
        if order.is_all_items_wait_ship
          if order.change_state_wait_ship(params[:order][:international_waybill_company])
            flash[:notice] = '订单审核完成!'
            redirect_to action: :index
          else
            flash[:alert] = '订单审核失败, 请重新操作!'
            redirect_to action: :index
          end
        else
          flash[:alert] = '还有货品未审核，请先审核货品!'
          redirect_to action: :show_checked_order, id: order.id
        end
      end

      def show_ship_order
        @order = Order.find(params[:id])
      end

      def ship_order
        @order = Order.find(params[:order][:id])
        international_waybill_no = params[:order][:international_waybill_no]
        if international_waybill_no == nil || international_waybill_no == ''
          @order.errors.add(:international_waybill_no, '国际运单号不能为空')
          render :show_ship_order
        else
          if @order.total_price = @order.trade_point
            status = 'T'
          else
            status = send_items_by_alipay(@order)
          end

          if status == 'T'
            @order.change_state_completed(params[:order][:international_waybill_no])
            flash[:notice] = '订单发货完成!'
            redirect_to action: :index
          else
            flash[:alert] = '调用淘宝发货接口失败, 请重新操作!'
            redirect_to action: :index
          end
        end
      end

      def add_share_point
        order = Order.find(params[:id])
        if order.add_share_point(params[:share])
          flash[:notice] = '积分增加成功!'
        else
          flash[:alert] = '积分增加失败,请重新操作!'
        end
        redirect_to action: :index
      end

      def get_receiver_pdf
        order = Order.find(params[:id])
        respond_to do |format|
          format.html {
            send_file order.get_receiver_pdf_url, :type => 'application/pdf', :disposition => 'inline'
          }
        end
      end

    end
  end
end