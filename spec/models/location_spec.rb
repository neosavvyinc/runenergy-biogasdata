require 'spec_helper'

describe Location do

  let :texas do
    FactoryGirl.create(:state, :name => "Texas")
  end

  let :us do
    FactoryGirl.create(:country, :name => "US")
  end

  let :location do
    FactoryGirl.create(:location, :state => texas, :country => us)
  end

  let :monitor_classes do
    def mc_location(mc)
      mc.locations << location
      mc
    end

    [
        mc_location(FactoryGirl.create(:monitor_class)),
        mc_location(FactoryGirl.create(:monitor_class)),
        mc_location(FactoryGirl.create(:monitor_class))
    ]
  end

  before(:each) do
    monitor_classes[0].monitor_points << FactoryGirl.create(:monitor_point, :name => '0 Index')
    monitor_classes[1].field_log_points << FactoryGirl.create(:field_log_point, :name => '1 Index')
    monitor_classes[2].monitor_points << FactoryGirl.create(:monitor_point, :name => '2 Index')
  end

  describe 'display_name' do

    it 'should return the site_name if it is defined' do
      location.site_name = "The Dang Watering Hole!"
      location.display_name.should eq "The Dang Watering Hole!"
    end

    it 'should return a combination of Unnamed with the state and country if undefined' do
      location.display_name.should eq "Unnamed Texas, US"
    end

  end

  describe 'monitor_classes_with_points' do

    it 'should play nice with a location with no monitor_classes' do
      FactoryGirl.create(:location).monitor_classes_with_points.should eq([])
    end

    it 'should deliver a hash of length 3' do
      mcs = location.monitor_classes_with_points
      mcs.size.should eq(3)
    end

    it 'should convert the monitor_classes to json with monitor_points and field_log_points' do
      mcs = location.monitor_classes_with_points
      mcs[0][:monitor_points].size.should eq(1)
      mcs[0][:monitor_points][0]['name'].should eq('0 Index')
      mcs[1][:field_log_points].size.should eq(1)
      mcs[1][:field_log_points][0]['name'].should eq('1 Index')
      mcs[2][:monitor_points].size.should eq(1)
      mcs[2][:monitor_points][0]['name'].should eq('2 Index')
    end

  end


end