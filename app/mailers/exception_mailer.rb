class ExceptionMailer < ActionMailer::Base
  default from: 'tewen@neosavvy.com'

  def monitor_limit_email(type, location, monitor_point, limit_value, reading,  user = nil, other_email_address = nil)
    #View
    @location = location
    @monitor_point = monitor_point
    @limit_value = limit_value
    @reading = reading

    #Email
    primary_email = user.email || other_email_address
    if primary_email
      mail(to: primary_email,
           cc: primary_email != other_email_address ? other_email_address : nil,
           subject: "Monitor Reading Reached #{type} Limit")
    end
  end
end
