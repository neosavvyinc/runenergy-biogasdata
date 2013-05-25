class State < ActiveRecord::Base
  attr_accessible :name, :postal_code, :country_id
  belongs_to :country
end
