class RemoveQuantityToItems < ActiveRecord::Migration
  def change
    remove_column :items, :quantity
  end
end
