module Shipping
  module Buyer
    class ItemsController < ApplicationController

      def index
        @items = Item.includes(:sku).by_current_user(current_user).by_status(:new)
        @order = Order.new
      end

    end
  end
end
