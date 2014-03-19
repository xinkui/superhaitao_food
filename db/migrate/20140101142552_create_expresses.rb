class CreateExpresses < ActiveRecord::Migration
  def change
    create_table :expresses do |t|
      t.string :description
      t.string :name

      t.timestamps
    end
  end
end
