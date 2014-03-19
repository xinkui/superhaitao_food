class AddTradedAtToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :traded_at, :datetime
  end
end
