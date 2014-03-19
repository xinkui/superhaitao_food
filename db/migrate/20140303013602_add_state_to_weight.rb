class AddStateToWeight < ActiveRecord::Migration
  def change
    add_column :weights, :state, :boolean, default: true
  end
end
