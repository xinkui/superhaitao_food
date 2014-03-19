module Shipping
  module Admin
    class ItemsController < AdminController

      before_action :set_item, only: [:show, :edit, :update, :destroy, :checked_item]

      def index
        if params[:q] != nil
          @search_state_eq = params[:q][:state_eq]
          @search_user_name_cont = params[:q][:user_name_cont]
        end
        @search = Item.search(params[:q])
        @items = @search.result.includes(:user, :sku).order('created_at desc')
                          .paginate( :page => params[:page], :per_page => 15 )
      end

      def show

      end

      def new
        @item = Item.new
      end

      def edit

      end

      def create
        @item = Item.new(item_params)
        user = User.by_name(params[:user_name]).first
        if user
          @item.user = user
          if @item.save
            flash[:notice] = t('message.item.created_successfully')
            redirect_to shipping_admin_item_path(@item)
          else
            flash.now[:alert] = '货品保存失败, 请重新操作!'
            render action: 'new'
          end
        else
          @item.errors.add(:user, t('message.item.user_is_not_exist'))
          render action: 'new'
        end
      end

      def update
        if @item.update(item_params)
          redirect_to shipping_admin_item_path(@item), notice: t('message.item.created_successfully')
        else
          render action: 'edit'
        end
      end

      def destroy
        if @item.destroy
          redirect_to shipping_admin_items_path, notice: t('message.global.destroy_success')
        else
          redirect_to shipping_admin_items_path, alert: '已经有关联订单, 不能删除!'
        end
      end

      def checked_item
        begin
          @item.change_state_wait_ship
          flash[:notice] = '货品审核完成，请继续操作'
          redirect_to show_checked_order_shipping_admin_orders_path(id: @item.order.id)
        rescue Exception => errors
          flash[:alert] = '货品审核失败, 请重新操作'
          redirect_to show_checked_order_shipping_admin_orders_path(id: @item.order.id)
        end
      end

      private
      def set_item
        @item = Item.find(params[:id])
      end

      def item_params
        params.require(:item).permit(:express_name_internal, :express_no_internal,
                                     :weight, :is_send_mail, :state, :remark, :cargo_space,
                                     :id, :sku_id)
      end

    end
  end
end
