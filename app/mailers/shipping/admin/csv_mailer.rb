module Shipping
  module Admin
    class CsvMailer < ActionMailer::Base
      default :from => 'superhaitao@163.com'

      def send_csv_mail(has_bpost, time, file_path_root)
        attachments['dhl.txt'] = File.read("#{file_path_root}/dhl/#{time.strftime('%Y%m%d%H%M%S').to_s}/dhl.txt")
        if has_bpost
          attachments['bpost.txt'] = File.read("#{file_path_root}/bpost/#{time.strftime('%Y%m%d%H%M%S').to_s}/bpost.txt")
        end

        subject = '超级海淘CSV文件'
        body = "附件是#{time.strftime('%Y%m%d%H%M%S').to_s}生成的CSV文件"
        mail( :to => 'superhaitao@163.com',
              :subject => subject,
              :body => body)
      end
    end
  end
end