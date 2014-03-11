require 'spec_helper'

describe AssetPropertyValue do

  describe 'name' do

    it 'should return the name of the asset property if it is available' do
      FactoryGirl.create(:asset_property_value, :asset_property => FactoryGirl.create(:asset_property, :name => 'George')).name.should eq('George')
    end

  end

end
