class ChangeColumnsToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :is_share, :is_share_weixin
    add_column :users, :is_share_weibo, :boolean, default: false
  end
end
