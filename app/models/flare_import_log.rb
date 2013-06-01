class FlareImportLog < ActiveRecord::Base
  attr_accessible :flare_specification_id, :message, :likely_cause
  belongs_to :flare_specification

  def flare_unique_identifier
    flare_specification.try(:flare_unique_identifier) or "No Unique ID Provided"
  end
end
