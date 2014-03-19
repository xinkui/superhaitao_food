class SendMailJobs

  def send_items_create_mail
    items = Item.where( 'is_send_mail = ?', false )
    items.each do |item|
      Shipping::Buyer::ItemsMailer.send_create_mail(item).deliver
      item.update( is_send_mail: true )
    end
  end

  def send_orders_completed_mail
    orders = Order.where( 'is_send_mail_with_ship = ? and state = ?', false, 'completed' )
    orders.each do |order|
      Shipping::Buyer::OrdersMailer.send_order_completed_mail(order).deliver
      order.update( is_send_mail_with_ship: true )
    end
  end

  def send_orders_checked_mail
    orders = Order.where( 'is_send_mail_with_audit = ? and state = ?', false, 'wait_ship' )
    orders.each do |order|
      Shipping::Buyer::OrdersMailer.send_orders_checked_mail(order).deliver
      order.update( is_send_mail_with_audit: true )
    end
  end

end