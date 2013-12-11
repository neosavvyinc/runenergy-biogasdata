class FieldLog < DataAsStringModel
  attr_accessible :taken_at
  has_many :readings

  def self.find_or_create_by_data(data)
    unless data.nil?
      FieldLog.where(:data => data.to_json).first || FieldLog.create(:data => data)
    else
      raise 'You must pass valid data to find or create by data!'
    end
  end

  def as_json(options={})
    super(options).merge(:data => JSON.parse(self.data))
  end
end
