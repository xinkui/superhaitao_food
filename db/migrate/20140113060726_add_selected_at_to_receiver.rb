class AddSelectedAtToReceiver < ActiveRecord::Migration
  def change
    add_column :receivers, :selected_at, :datetime
  end
end
