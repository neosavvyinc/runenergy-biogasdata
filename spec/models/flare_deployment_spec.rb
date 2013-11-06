require 'spec_helper'

describe FlareDeployment do

  let :flare_specification do
    FactoryGirl.create(:flare_specification)
  end

  let :flare_deployment do
    FactoryGirl.create(:flare_deployment, :flare_specification => flare_specification)
  end

  describe 'current?' do
    it 'should return false if the flare_deployment_status_code is not current' do
      flare_deployment.flare_deployment_status_code = FlareDeploymentStatusCode.find_by_name("PAST")
      flare_deployment.current?.should be_false
    end

    it 'should return true when the flare_deployment_status_code is current' do
      flare_deployment.flare_deployment_status_code = FlareDeploymentStatusCode.find_by_name("CURRENT")
      flare_deployment.current?.should be_true
    end
  end

  describe 'apply_unique_identifier' do

    before(:each) do
      flare_specification.flare_unique_identifier = 'killed_by_death'
    end

    it 'should create a combination of the unique identifier of the flare specification and its own id' do
      flare_deployment.apply_unique_identifier
      flare_deployment.client_flare_unique_identifier.should eq "killed_by_death-#{flare_deployment.id}"
    end

    it 'should save the attribute to the db' do
      flare_deployment.apply_unique_identifier
      db_fd = FlareDeployment.find(flare_deployment.id)
      db_fd.client_flare_unique_identifier.should eq "killed_by_death-#{flare_deployment.id}"
    end

  end

end