class ChangeColumnsToSkus < ActiveRecord::Migration
  def change
    change_column :skus, :length, :decimal, :precision => 10, :scale => 2, :default => nil
    change_column :skus, :width, :decimal, :precision => 10, :scale => 2, :default => nil
    change_column :skus, :height, :decimal, :precision => 10, :scale => 2, :default => nil
    change_column :skus, :volume, :decimal, :precision => 10, :scale => 2, :default => nil
    change_column :skus, :actual_weight, :decimal, :precision => 10, :scale => 2, :default => nil
  end
end
