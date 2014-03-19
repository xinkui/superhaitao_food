class AddIsGenerateWaybillToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_generate_waybill, :boolean, default: true
  end
end
