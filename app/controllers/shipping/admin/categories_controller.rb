module Shipping
  module Admin
    class CategoriesController < AdminController
      before_action :set_category, only: [:show, :edit, :update, :destroy]

      # GET /categories
      # GET /categories.json
      def index
        @categories = Category.all.paginate(:page => params[:page], :per_page => 15)
      end

      # GET /categories/1
      # GET /categories/1.json
      def show
      end

      # GET /categories/new
      def new
        @category = Category.new
      end

      # GET /categories/1/edit
      def edit
      end

      # POST /categories
      # POST /categories.json
      def create
        @category = Category.new(category_params)

        respond_to do |format|
          if @category.save
            format.html { redirect_to shipping_admin_category_path(@category), notice: '货品类别创建成功!' }
          else
            format.html { render action: 'new' }
          end
        end
      end

      # PATCH/PUT /categories/1
      # PATCH/PUT /categories/1.json
      def update
        respond_to do |format|
          if @category.update(category_params)
            format.html { redirect_to shipping_admin_category_path(@category), notice: '货品类别更新成功!' }
            format.json { head :no_content }
          else
            format.html { render action: 'edit' }
            format.json { render json: @category.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /categories/1
      # DELETE /categories/1.json
      def destroy
        begin
          @category.destroy
          flash[:notice] = '货品删除成功!'
        rescue ActiveRecord::DeleteRestrictionError
          flash[:alert] = '货品类别删除失败, 可能存在SKU关联, 请确认!'
        rescue Exception => errors
          flash[:alert] = '货品类别删除失败, 请重新操作!'
        end
        redirect_to shipping_admin_brands_path
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_category
        @category = Category.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def category_params
        params.require(:category).permit(:name_cn, :name_en, :remark)
      end
    end
  end
end
