class AddInternationalWaybillNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :international_waybill_number, :string
  end
end
