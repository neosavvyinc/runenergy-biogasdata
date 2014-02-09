require 'spec_helper'

describe Asset do

  let :location do
    FactoryGirl.create(:location)
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :other_location do
    FactoryGirl.create(:location)
  end

  let :asset do
    FactoryGirl.create(:asset, :location => location, :monitor_class => monitor_class, :unique_identifier => '78HFG')
  end

  before(:each) do
    asset.should_not be_nil
  end

  describe 'self.lazy_load' do

    it 'should grab the object from db if it exists' do
      Asset.lazy_load(location.id, monitor_class.id, '78HFG').id.should eq(asset.id)
    end

    it 'should create the object if it does not exist in db' do
      Asset.lazy_load(other_location.id, monitor_class.id, '78HFG').id.should_not eq(asset.id)
    end

    it 'should create the object if it doesnt exist via other field' do
      Asset.lazy_load(location.id, monitor_class.id, 'NOTRIGHT').id.should_not eq(asset.id)
    end

  end

end
