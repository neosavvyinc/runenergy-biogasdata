class FlareImportLog < ActiveRecord::Base
  attr_accessible :flare_specification_id, :message, :likely_cause
  belongs_to :flare_specification
end
