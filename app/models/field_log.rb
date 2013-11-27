class FieldLog < ActiveRecord::Base
  attr_accessible :data, :taken_at
  has_many :readings

  def as_json(options={})
    super(options).merge(:data => JSON.parse(self.data))
  end
end
