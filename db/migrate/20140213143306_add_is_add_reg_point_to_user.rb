class AddIsAddRegPointToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_add_reg_point, :boolean, default: false
  end
end
