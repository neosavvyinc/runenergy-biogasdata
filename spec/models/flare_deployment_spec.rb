require "spec_helper"

describe FlareDeployment do

  let :flare_specification do
    FactoryGirl.create(:flare_specification)
  end

  let :flare_deployment do
    FactoryGirl.create(:flare_deployment, :flare_specification => flare_specification)
  end

  describe "current?" do
    it 'should return false if the flare_deployment_status_code is not current' do
      flare_deployment.flare_deployment_status_code = FlareDeploymentStatusCode.find_by_name("PAST")
      flare_deployment.current?.should be_false
    end

    it 'should return true when the flare_deployment_status_code is current' do
      flare_deployment.flare_deployment_status_code = FlareDeploymentStatusCode.find_by_name("CURRENT")
      flare_deployment.current?.should be_true
    end
  end
  
end