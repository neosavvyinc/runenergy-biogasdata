class FieldLog < ActiveRecord::Base
  attr_accessible :data, :taken_at
  has_many :readings
end
