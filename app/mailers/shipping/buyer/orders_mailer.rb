module Shipping
  module Buyer
    class OrdersMailer < ActionMailer::Base
      default :from => 'superhaitao@163.com'

      def send_order_completed_mail(order)
        @order = order
        subject = '超级海淘出库通知'
        mail( :to => @order.user.email, :subject => subject)
      end

      def send_orders_checked_mail(order)
        @order = order
        subject = '超级海淘订单审核通知'
        mail( :to => @order.user.email, :subject => subject)
      end
    end
  end
end
