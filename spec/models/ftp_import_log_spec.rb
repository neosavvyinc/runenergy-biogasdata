require 'spec_helper'

describe FtpImportLog do

  let :ftp_import_log do
    FactoryGirl.create(:ftp_import_log, :ftp_detail => FactoryGirl.create(:ftp_detail, :asset => FactoryGirl.create(:asset, :unique_identifier => '25OR624')))
  end
  
  describe 'display_name' do

    it 'should return a concatenation of the assets name and the created date, formatted' do
      ftp_import_log.display_name.should eq("#{ftp_import_log.ftp_detail.try(:asset).try(:display_name)} on #{ftp_import_log.created_at.strftime('%b %e, %H:%M')}")
    end
    
  end

end
