class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.00
      t.string :express_id
      t.string :weight_id

      t.timestamps
    end
  end
end
