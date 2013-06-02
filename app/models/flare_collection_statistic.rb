class FlareCollectionStatistic < ActiveRecord::Base
  attr_accessible :last_reading_collected, :last_csv_read
  has_one :flare_specification

  def display_name
    flare_specification.try(:flare_unique_identifier)
  end
end
