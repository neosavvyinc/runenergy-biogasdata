class ExceptionNotification < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :other_email, :user_id
  belongs_to :locations_monitor_class
  belongs_to :user

  validates_presence_of :locations_monitor_class_id

  def display_name
    user.try(:name) || other_email
  end

  def lower_limit_warning(locations_monitor_class, monitor_point, monitor_limit, reading)
    ExceptionMailer.monitor_limit_email('Upper',
                                        locations_monitor_class.location,
                                        monitor_point, monitor_limit.upper_limit,
                                        reading, user, other_email).deliver
  end

  def upper_limit_warning(locations_monitor_class, monitor_point, monitor_limit, reading)
    ExceptionMailer.monitor_limit_email('Lower',
                                        locations_monitor_class.location,
                                        monitor_point, monitor_limit.lower_limit,
                                        reading, user, other_email).deliver
  end

  protected

end
