class ExceptionNotification < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :other_email, :user_id
  belongs_to :locations_monitor_class
  belongs_to :user

  validates_presence_of :locations_monitor_class_id

  def display_name
    user.try(:name) || other_email
  end
end
