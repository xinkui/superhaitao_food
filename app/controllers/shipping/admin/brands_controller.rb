module Shipping
  module Admin
    class BrandsController < AdminController
      before_action :set_brand, only: [:show, :edit, :update, :destroy]

      # GET /brands
      # GET /brands.json
      def index
        @brands = Brand.all.paginate(:page => params[:page], :per_page => 15)
      end

      # GET /brands/1
      # GET /brands/1.json
      def show
      end

      # GET /brands/new
      def new
        @brand = Brand.new
      end

      # GET /brands/1/edit
      def edit
      end

      # POST /brands
      # POST /brands.json
      def create
        @brand = Brand.new(brand_params)

        respond_to do |format|
          if @brand.save
            format.html { redirect_to shipping_admin_brand_path(@brand), notice: '品牌创建成功!' }
          else
            format.html { render action: 'new' }
          end
        end
      end

      # PATCH/PUT /brands/1
      # PATCH/PUT /brands/1.json
      def update
        respond_to do |format|
          if @brand.update(brand_params)
            format.html { redirect_to shipping_admin_brand_path(@brand), notice: '品牌更新成功!' }
            format.json { head :no_content }
          else
            format.html { render action: 'edit' }
            format.json { render json: @brand.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /brands/1
      # DELETE /brands/1.json
      def destroy
        begin
          @brand.destroy
          flash[:notice] = '品牌删除成功!'
        rescue ActiveRecord::DeleteRestrictionError
          flash[:alert] = '品牌删除失败, 可能存在SKU关联, 请确认!'
        rescue Exception => errors
          flash[:alert] = '品牌删除失败, 请重新操作!'
        end
        redirect_to shipping_admin_brands_path
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_brand
        @brand = Brand.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def brand_params
        params.require(:brand).permit(:name_cn, :name_en, :remark)
      end
    end
  end
end
