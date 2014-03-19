class AddActiveToReceiver < ActiveRecord::Migration
  def change
    add_column :receivers, :active, :boolean, :default => true
  end
end
