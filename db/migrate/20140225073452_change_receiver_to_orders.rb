class ChangeReceiverToOrders < ActiveRecord::Migration
  def change
    remove_reference :orders, :receiver, index: true
    add_column :orders, :receiver_message, :string
  end
end
