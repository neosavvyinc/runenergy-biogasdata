require 'spec_helper'

describe LocationsMonitorClass do

  let :location do
    FactoryGirl.create(:location, :site_name => 'Tom Landfill')
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class, :name => 'Shorty')
  end

  let :locations_monitor_class do
    FactoryGirl.create(:locations_monitor_class, :location => location, :monitor_class => monitor_class)
  end

  describe 'display_name' do
    it 'should return the location and then pluralized monitor class name' do
      locations_monitor_class.display_name.should eq('Tom Landfill - Shorties')
    end  
  end

end