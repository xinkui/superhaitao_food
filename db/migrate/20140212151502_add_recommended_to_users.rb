class AddRecommendedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recommended, :string
  end
end
