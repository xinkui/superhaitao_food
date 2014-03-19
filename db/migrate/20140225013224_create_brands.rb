class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name_cn
      t.string :name_en
      t.string :remark

      t.timestamps
    end
  end
end
