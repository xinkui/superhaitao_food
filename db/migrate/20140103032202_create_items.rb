class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :express_name_internal
      t.string :express_no_internal
      t.decimal :weight, :precision => 10, :scale => 2, :default => 0.00
      t.boolean :is_send_mail,  :default => false
      t.string :state
      t.string :remark
      t.string :cargo_space

      t.references :user
      t.timestamps
    end

    add_index :items, :is_send_mail
    add_index :items, :state
  end
end
