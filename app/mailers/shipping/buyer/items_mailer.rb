module Shipping
  module Buyer
    class ItemsMailer < ActionMailer::Base
      default :from => 'superhaitao@163.com'

      def send_create_mail(item)
        @item = item
        subject = '超级海淘入库通知'
        mail( :to => @item.user.email, :subject => subject)
      end
    end
  end
end

