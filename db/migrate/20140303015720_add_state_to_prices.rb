class AddStateToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :state, :boolean, default: true
  end
end
