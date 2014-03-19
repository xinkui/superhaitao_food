class AddIsSendMailToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :is_send_mail, :boolean, index: true, default: false
  end
end
