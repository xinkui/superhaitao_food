class AddExpressToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :express, :index => true
  end
end
