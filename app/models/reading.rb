class Reading < DataAsStringModel
  attr_accessible :taken_at, :monitor_class_id, :field_log_id, :location_id, :asset_id
  belongs_to :location
  belongs_to :monitor_class
  belongs_to :field_log
  belongs_to :asset

  def as_json(options={})
    super(options).merge({
                             :data => JSON.parse(self.data),
                             :field_log => self.field_log.as_json
                         })
  end
end
