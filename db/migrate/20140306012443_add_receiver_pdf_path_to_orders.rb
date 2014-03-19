class AddReceiverPdfPathToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :receiver_pdf_path, :string
  end
end
