class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.string :state
      t.decimal :total_price, :precision => 10, :scale => 2, :default => 0.00

      t.references :user
      t.timestamps
    end
  end
end
