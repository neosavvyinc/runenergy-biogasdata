require 'spec_helper'

describe Asset do

  let :asset do
    asset = FactoryGirl.create(:asset)
    asset.monitor_points << FactoryGirl.create(:monitor_point)
    asset.monitor_points << FactoryGirl.create(:monitor_point)
    asset
  end

  before(:each) do
    asset.should_not be_nil
  end

  describe 'as_json' do

    it 'should include all the monitor_points assigned to the asset' do
      asset.as_json[:monitor_points].size.should eq(2)
    end
    
  end

end
