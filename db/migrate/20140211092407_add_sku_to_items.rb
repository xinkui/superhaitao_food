class AddSkuToItems < ActiveRecord::Migration
  def change
    add_reference :items, :sku, index: true
  end
end
