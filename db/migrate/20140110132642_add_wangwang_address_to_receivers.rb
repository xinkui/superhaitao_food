class AddWangwangAddressToReceivers < ActiveRecord::Migration
  def change
    add_column :receivers, :wangwang, :string
    add_column :receivers, :address, :string
  end
end
