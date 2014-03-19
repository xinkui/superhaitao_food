class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_share_weixin, :boolean, default: false
    add_column :orders, :is_share_weibo, :boolean, default: false
  end
end
