class ChangeInternationalWaybillColumnsToOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :international_waybill_number, :international_waybill_no
    add_column :orders, :international_waybill_company, :string
  end
end
