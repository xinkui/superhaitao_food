class RemoveStateToWeights < ActiveRecord::Migration
  def change
    remove_column :weights, :state
  end
end
