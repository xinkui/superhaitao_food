class AddWeiboWeixinIsShareToUser < ActiveRecord::Migration
  def change
    add_column :users, :weibo, :string
    add_column :users, :weixin, :string
    add_column :users, :is_share, :boolean, default: false
  end
end
