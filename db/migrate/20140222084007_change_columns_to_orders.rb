class ChangeColumnsToOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :is_send_mail, :is_send_mail_with_audit
    add_column :orders, :is_send_mail_with_ship, :boolean, index: true, default: false
  end
end
