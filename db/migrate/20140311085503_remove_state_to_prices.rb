class RemoveStateToPrices < ActiveRecord::Migration
  def change
    remove_column :prices, :state
  end
end
