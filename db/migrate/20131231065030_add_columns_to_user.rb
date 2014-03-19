class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :point, :decimal, :precision => 10, :scale => 2, :default => 0.00
    add_column :users, :receipt_logo, :string
    add_column :users, :name_cn, :string
    add_column :users, :phone, :string
    add_column :users, :balance, :decimal, :precision => 10, :scale => 2, :default => 0.00
    add_column :users, :name_en_first, :string
    add_column :users, :name_en_last, :string

    add_index :users, :receipt_logo,                :unique => true
  end

end
