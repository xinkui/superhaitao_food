class AddRoleStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: 'buyers'
    add_column :users, :state, :string, default: 'active'
  end
end
