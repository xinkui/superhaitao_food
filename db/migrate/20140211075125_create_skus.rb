class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :name
      t.decimal :length, :precision => 10, :scale => 2, :default => 0.00
      t.decimal :width, :precision => 10, :scale => 2, :default => 0.00
      t.decimal :height, :precision => 10, :scale => 2, :default => 0.00
      t.decimal :volume, :precision => 10, :scale => 2, :default => 0.00
      t.decimal :actual_weight, :precision => 10, :scale => 2, :default => 0.00
      t.string :barcode
      t.string :remark

      t.timestamps
    end
  end
end
