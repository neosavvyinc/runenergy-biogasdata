require 'spec_helper'
require 'json'

describe SummaryController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  describe 'locations' do
    before(:each) do
      FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
      FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
      FactoryGirl.create(:location)
      FactoryGirl.create(:section)
      FactoryGirl.create(:section)
      FactoryGirl.create(:section)
      FactoryGirl.create(:asset)
      FactoryGirl.create(:monitor_class)
      FactoryGirl.create(:monitor_class)
      FactoryGirl.create(:monitor_class)
      FactoryGirl.create(:monitor_class)
      sign_in overseer
      get :locations
    end

    it 'should set the @landfill_operators variable to all the customer type users' do
      controller.instance_variable_get(:@landfill_operators).size.should eq(2)
    end

    it 'should set the @sites to Location.all' do
      controller.instance_variable_get(:@sites).size.should be > 0
    end

    it 'should set the @sections to Section.all' do
      controller.instance_variable_get(:@sections).size.should be > 0
    end

    it 'should set the @assets to Asset.all' do
      controller.instance_variable_get(:@assets).size.should be > 0
    end

    it 'should set the @monitor_classes to MonitorClass.all' do
      controller.instance_variable_get(:@monitor_classes).size.should be > 0
    end

    it 'should set the @filter_types to DataAnalysisFilter mapping' do
      controller.instance_variable_get(:@filter_types).size.should be > 0
    end
  end

end