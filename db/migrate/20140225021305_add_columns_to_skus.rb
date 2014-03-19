class AddColumnsToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :name_en, :string
    add_column :skus, :made_in_germany, :boolean
    add_reference :skus, :brand, index: true
    add_reference :skus, :category, index: true
    add_column :skus, :purchase_price, :decimal, :precision => 10, :scale => 2
  end
end
