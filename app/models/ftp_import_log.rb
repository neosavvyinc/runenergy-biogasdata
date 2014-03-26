class FtpImportLog < ActiveRecord::Base
  attr_accessible :error, :ftp_detail_id
  belongs_to :ftp_detail

  validates_presence_of :ftp_detail

  def display_name
    "#{ftp_detail.try(:asset).try(:display_name)} on #{self.created_at.strftime('%b %e, %H:%M')}"
  end
end
