class RemoveColumnsToUser < ActiveRecord::Migration
  def change
    remove_columns :users, :receipt_logo, :name_cn, :name_en_first, :name_en_last
  end
end
