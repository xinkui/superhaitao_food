module Shipping
  module Admin
    class PricesController < AdminController
      before_action :set_price, only: [:show, :edit, :update, :destroy]

      # GET /prices
      # GET /prices.json
      def index
        @prices = Price.includes(:weight).paginate(:page => params[:page], :per_page => 15)
      end

      # GET /prices/1
      # GET /prices/1.json
      def show
      end

      # GET /prices/new
      def new
        @price = Price.new
      end

      # GET /prices/1/edit
      def edit
      end

      # POST /prices
      # POST /prices.json
      def create
        @price = Price.new(price_params)
        if @price.save
          redirect_to shipping_admin_price_path(@price), notice: '价格添加成功！'
        else
          render action: 'new'
        end
      end

      # PATCH/PUT /prices/1
      # PATCH/PUT /prices/1.json
      def update
        if @price.update(price_params)
          redirect_to shipping_admin_price_path(@price), notice: '价格修改成功！'
        else
          render action: 'edit'
        end
      end

      # DELETE /prices/1
      # DELETE /prices/1.json
      def destroy
        @price.destroy
        redirect_to shipping_admin_prices_path, notice: t('message.global.destroy_success')
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_price
        @price = Price.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def price_params
        params.require(:price).permit(:price, :weight_id)
      end
    end
  end
end
