require 'spec_helper'

describe FlareImportLog do

  let :flare_specification do
    FactoryGirl.create(:flare_specification, :flare_unique_identifier => "My Cousin Vinnie")
  end

  let :flare_import_log do
    FactoryGirl.create(:flare_import_log, :flare_specification => flare_specification)
  end

  describe 'flare_unique_identifier' do

    it 'should return the flare_unique_identifier property of the flare_specification if defined' do
      flare_import_log.flare_unique_identifier.should eq "My Cousin Vinnie"
    end

    it 'should return No Unique ID Provided when the unique identifier is not defined' do
      flare_import_log.flare_specification = nil
      flare_import_log.flare_unique_identifier.should eq "No Unique ID Provided"
    end

  end

end