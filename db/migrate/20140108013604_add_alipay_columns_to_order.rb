class AddAlipayColumnsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :trade_no, :string
    add_column :orders, :gmt_create, :datetime
    add_column :orders, :gmt_payment, :datetime


    add_index :orders, :trade_no
  end
end
