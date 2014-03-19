class RemoveTableExpress < ActiveRecord::Migration
  def change
    drop_table :expresses
  end
end
