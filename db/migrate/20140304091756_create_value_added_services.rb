class CreateValueAddedServices < ActiveRecord::Migration
  def change
    create_table :value_added_services do |t|
      t.string :name
      t.string :price, :precision => 10, :scale => 2

      t.belongs_to :order
      t.timestamps
    end
  end
end
