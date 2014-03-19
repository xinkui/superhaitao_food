class AddTradePointToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :trade_point, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
