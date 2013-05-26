class FlareSpecification < ActiveRecord::Base
  attr_accessible :capacity_scmh, :data_location, :flare_id, :ftp_address, :manufacturer_id, :manufacturer_product_id, :owner_id, :password, :purchase_date, :username, :web_address
  belongs_to :owner, :class_name => 'Company', :foreign_key => 'owner_id'
  belongs_to :manufacturer, :class_name => 'Company', :foreign_key => 'manufacturer_id'
  belongs_to :flare_collection_statistic
  has_one :flare_deployment

  def update_statistic(csv_file_name)
    unless csv_file_name.blank?
      flare_collection_statistic = self.flare_collection_statistic || FlareCollectionStatistic.new(:flare_specification => self)
      flare_collection_statistic.last_reading_collected = Date.strptime(csv_file_name.gsub(/[^0-9]/), "%d%m%Y")
      flare_collection_statistic.last_csv_read = csv_file_name
      flare_collection_statistic.save
    else
      raise "You have passed in a blank csv file name for updating, this is invalid"
    end
  end

  def next_csv
    if self.flare_collection_statistic
      (self.flare_collection_statistic.last_reading_collected + 1.day).strftime("%d%m%Y") + ".CSV"
    else
      nil
    end
  end
end
