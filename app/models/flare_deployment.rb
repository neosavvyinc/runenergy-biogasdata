class FlareDeployment < ActiveRecord::Base
  attr_accessible :client_flare_unique_identifier, :customer_id, :flare_data_mapping_id, :flare_specification_id, :location_id, :first_reading, :last_reading, :flare_deployment_status_code_id
  belongs_to :flare_specification
  belongs_to :location
  belongs_to :customer, :class_name => 'User', :foreign_key => 'customer_id'
  belongs_to :flare_deployment_status_code

  validates_presence_of :flare_specification
  after_create :apply_unique_identifier
  before_save :apply_deployment_status

  def current?
    flare_deployment_status_code == FlareDeploymentStatusCode.CURRENT
  end

  def apply_unique_identifier
    update_attribute(:client_flare_unique_identifier, "#{self.flare_specification.flare_unique_identifier}-#{id}")
  end

  def apply_deployment_status
    if last_reading.blank?
      self.flare_deployment_status_code = FlareDeploymentStatusCode.CURRENT
    else
      self.flare_deployment_status_code = FlareDeploymentStatusCode.PAST
    end
  end

  def min_date(date_time)
    if date_time.blank?
      self.first_reading
    elsif self.first_reading.blank?
      date_time
    else
      [self.first_reading, date_time].max
    end
  end

  def max_date(date_time)
    if self.last_reading.blank?
      date_time
    elsif date_time.blank?
      self.last_reading + 1.day - 1.minute
    else
      [self.last_reading + 1.day - 1.minute, date_time.to_time].min
    end
  end
end
