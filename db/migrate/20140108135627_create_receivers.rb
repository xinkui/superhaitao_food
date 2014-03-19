class CreateReceivers < ActiveRecord::Migration
  def change
    create_table :receivers do |t|
      t.string :name
      t.string :zip_code
      t.string :phone

      t.references :user
      t.references :province
      t.references :city
      t.references :district
      t.timestamps
    end

    add_index :receivers, :user_id
  end
end
