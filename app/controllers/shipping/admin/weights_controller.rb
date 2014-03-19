module Shipping
  module Admin
    class WeightsController < AdminController
      before_action :set_weight, only: [:show, :edit, :update, :destroy]

      # GET /weights
      # GET /weights.json
      def index
        @weights = Weight.all.paginate(:page => params[:page], :per_page => 15)
      end

      # GET /weights/1
      # GET /weights/1.json
      def show
      end

      # GET /weights/new
      def new
        @weight = Weight.new
      end

      # GET /weights/1/edit
      def edit
      end

      # POST /weights
      # POST /weights.json
      def create
        @weight = Weight.new(weight_params)
        if @weight.save
          redirect_to shipping_admin_weight_path(@weight), notice: '重量添加成功！'
        else
          render action: 'new'
        end
      end

      # PATCH/PUT /weights/1
      # PATCH/PUT /weights/1.json
      def update
        if @weight.update(weight_params)
          redirect_to shipping_admin_weight_path(@weight), notice: '重量修改成功！'
        else
          render action: 'edit'
        end
      end

      # DELETE /weights/1
      # DELETE /weights/1.json
      def destroy
        begin
          @weight.destroy
          flash[:notice] = '重量删除成功!'
        rescue ActiveRecord::DeleteRestrictionError
          flash[:alert] = '重量删除失败, 可能存在价格关联, 请确认!'
        rescue Exception => errors
          flash[:alert] = '重量删除失败, 请重新操作!'
        end
        redirect_to shipping_admin_weights_path
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_weight
        @weight = Weight.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def weight_params
        params.require(:weight).permit(:weight)
      end
    end
  end
end
