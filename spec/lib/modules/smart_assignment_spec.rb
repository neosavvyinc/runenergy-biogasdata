require 'spec_helper'

describe SmartAssignment do

  let :fmd do
    FactoryGirl.create(:flare_monitor_data)
  end
  
  describe 'attributes_ignore_unknown' do

    it 'should work fine with known attributes' do
      fmd.attributes_ignore_unknown = {:blower_speed => 78}
      fmd.save

      my_fmd = FlareMonitorData.find(fmd.id)
      my_fmd.blower_speed.should eq(78)
    end

    it 'should ignore unknown attributes for saving' do
      fmd.attributes_ignore_unknown = {:name => 'Stanville', :blower_speed => 90}
      fmd.save

      my_fmd = FlareMonitorData.find(fmd.id)
      my_fmd.blower_speed.should eq(90)
    end
    
  end

end