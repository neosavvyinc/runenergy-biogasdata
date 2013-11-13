FactoryGirl.define do
  factory :flare_deployment_status_code do |val|

  end
  factory :flare_deployment do |val|
    FlareDeploymentStatusCode.find_by_name("CURRENT") or FactoryGirl.create(:flare_deployment_status_code, :name => "CURRENT")
    FlareDeploymentStatusCode.find_by_name("PAST") or FactoryGirl.create(:flare_deployment_status_code, :name => "PAST")

    before :create do |flare_deployment|
      if flare_deployment.flare_specification.blank?
        flare_deployment.flare_specification = FactoryGirl.create(:flare_specification)
        flare_deployment.save
      end
    end
  end
end