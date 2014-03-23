class MailPreview < MailView
  def batch_limit
    location = Location.find(8)
    monitor_class = MonitorClass.find(2)
    readings = Reading.where(created_at: "2014-03-23 00:32:41")
    type = "Upper"
    deleted = readings.last(5)
    user = nil
    other_email_address = "andrew.jorczak@gmail.com"
    ExceptionMailer.batch_monitor_limit_email(type, location, monitor_class, readings, deleted, user, other_email_address)
  end
end