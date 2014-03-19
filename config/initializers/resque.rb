scheduler = Rufus::Scheduler.start_new

scheduler.every(4.minutes) do
  SendMailJobs.new.send_items_create_mail
  ActiveRecord::Base.connection.close
  SendMailJobs.new.send_orders_completed_mail
  ActiveRecord::Base.connection.close
  SendMailJobs.new.send_orders_checked_mail
  ActiveRecord::Base.connection.close
end


scheduler.every(3.minutes) do
  GenerateWaybillJob.new.generate_waybill
  ActiveRecord::Base.connection.close
end