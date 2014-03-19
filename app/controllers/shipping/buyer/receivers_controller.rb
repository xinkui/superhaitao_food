module Shipping
  module Buyer
    class ReceiversController < ApplicationController
      before_action :set_receiver, only: [:show, :edit, :update, :destroy]

      def index
        @receivers = Receiver.includes(:province, :city, :district).by_user(current_user).by_active_true
      end

      def show
      end

      def new
        @receiver = Receiver.new
      end

      def edit
      end

      def create
        @receiver = Receiver.new(receiver_params)
        @receiver.user_id = current_user.id

        if @receiver.save
          redirect_to shipping_buyer_receiver_path(@receiver), notice: '收件人添加成功!'
        else
          render action: 'new'
        end
      end

      def update
        if @receiver.update_attributes(receiver_params)
          redirect_to shipping_buyer_receiver_path(@receiver), notice: '收件人更新成功!'
        else
          render action: 'edit'
        end
      end

      def destroy
        @receiver.update_attribute(:active, false)
        redirect_to shipping_buyer_receivers_path, notice: '收件人删除成功!'
      end

      private
      def set_receiver
        @receiver = Receiver.by_user(current_user).find(params[:id])
      end

      def receiver_params
        params.require(:receiver).permit(:id, :province_id, :city_id, :district_id, :name, :zip_code, :phone, :user_id,
                                         :active, :address)
      end

    end
  end
end