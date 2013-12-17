require 'spec_helper'
require 'json'

describe DataAnalysisController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  before(:each) do
    sign_in overseer
  end

  describe 'index' do
  
  end

  describe 'readings' do

    it 'should return a 400 error if not passed a landfill_operator_id in the request' do
      xhr :get, 'readings', :site_id => 24, :section_id => 18, :monitor_class_id => 16, :landfill_operator_id => 'null'
      response.status.should eq(400)
    end

    it 'should return a 400 error if not passed a site_id in the request' do
      xhr :get, 'readings', :landfill_operator_id => 24, :section_id => 18, :monitor_class_id => 16
      response.status.should eq(400)
    end

    it 'should return a 400 error if not passed a section_id in the request' do
      xhr :get, 'readings', :site_id => 24, :landfill_operator_id => 29, :monitor_class_id => 16
      response.status.should eq(400)
    end

    it 'should return a 400 error if not passed a monitor_class_id in the request' do
      xhr :get, 'readings', :site_id => 24, :section_id => 18, :landfill_operator_id => 29
      response.status.should eq(400)
    end
    
  end
end