class FtpColumnMonitorPoint < ActiveRecord::Base
  attr_accessible :format, :ftp_detail_id, :monitor_point_id, :column_name
  belongs_to :ftp_detail
  belongs_to :monitor_point
end
