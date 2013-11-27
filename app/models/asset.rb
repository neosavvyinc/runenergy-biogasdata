class Asset < ActiveRecord::Base
  attr_accessible :name, :section_id
  belongs_to :section
end
