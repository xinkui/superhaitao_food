class AddReceiverToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :receiver, :index => true
  end
end
