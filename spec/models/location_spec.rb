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

  describe 'display_name' do

    it 'should return the site_name if it is defined' do
      location.site_name = "The Dang Watering Hole!"
      location.display_name.should eq "The Dang Watering Hole!"
    end

    it 'should return a combination of Unnamed with the state and country if undefined' do
      location.display_name.should eq "Unnamed Texas, US"
    end
    
  end
  
end