module Shipping
  module Admin
    class SkusController < AdminController
      before_action :set_sku, only: [:show, :edit, :update, :destroy]

      # GET /skus
      # GET /skus.json
      def index
        @skus = Sku.all

        if params[:q] != nil
          @search_name_cont = params[:q][:name_cont]
          @search_barcode_cont = params[:q][:barcode_cont]
        end
        @search = Sku.search(params[:q])
        @skus = @search.result.includes(:brand, :category).order('created_at desc').paginate(:page => params[:page], :per_page => 15)
      end

      # GET /skus/1
      # GET /skus/1.json
      def show
      end

      # GET /skus/new
      def new
        @sku = Sku.new
      end

      # GET /skus/1/edit
      def edit
      end

      # POST /skus
      # POST /skus.json
      def create
        @sku = Sku.new(sku_params)

        respond_to do |format|
          if @sku.save
            format.html { redirect_to shipping_admin_sku_path(@sku), notice: 'Sku新增成功.' }
          else
            format.html { render action: 'new' }
          end
        end
      end

      # PATCH/PUT /skus/1
      # PATCH/PUT /skus/1.json
      def update
        respond_to do |format|
          if @sku.update(sku_params)
            format.html { redirect_to shipping_admin_sku_path(@sku), notice: 'Sku更新成功.' }
          else
            format.html { render action: 'edit' }
          end
        end
      end

      # DELETE /skus/1
      # DELETE /skus/1.json
      def destroy
        if @sku.destroy
          flash[:notice] = 'Sku删除成功!'
        else
          flash[:alert] = 'Sku删除失败, 可能存在item关联!'
        end
        redirect_to shipping_admin_skus_path
      end

      def get_sku_ajax
        sku = Sku.by_barcode(params[:barcode])
        render json: sku
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_sku
        @sku = Sku.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def sku_params
        params.require(:sku).permit(:name, :length, :width, :height, :name_en, :brand_id, :category_id, :purchase_price,
                                    :made_in_germany, :actual_weight, :volume, :barcode, :remark)
      end
    end
  end
end
