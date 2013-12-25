require 'spec_helper'

describe Section do

  let :location do
    FactoryGirl.create(:location, :site_name => 'Waco')
  end

  let :section do
    FactoryGirl.create(:section, :name => 'Area 54')
  end

  describe 'display_name' do
    it 'should return No location specified - + name if no location is specified' do
      section.display_name.should eq('No Location Specified - Area 54')
    end

    it 'should return location.site_name - name when location is specified' do
      section.location = location
      section.save
      section.display_name.should eq('Waco - Area 54')
    end
  end
  
end