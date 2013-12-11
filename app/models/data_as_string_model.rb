class DataAsStringModel < ActiveRecord::Base
  attr_accessible :data
  before_save :stringify_data

  def stringify_data
    unless self.data.nil? or self.data.is_a? String
      self.data = self.data.to_json
    end
  end

  self.abstract_class = true
end