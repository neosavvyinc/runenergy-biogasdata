class FtpDetail < ActiveRecord::Base
  attr_accessible :asset_id, :password, :url, :username, :ftp_column_monitor_points_attributes
  belongs_to :asset
  has_many :ftp_column_monitor_points

  accepts_nested_attributes_for :ftp_column_monitor_points, :allow_destroy => true
end
