class RemoveWangwangToReceivers < ActiveRecord::Migration
  def change
    remove_column :receivers, :wangwang
  end
end
