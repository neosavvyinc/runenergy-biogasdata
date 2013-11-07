FactoryGirl.define do
  factory :flare_deployment_status_code do |val|

  end
  factory :flare_deployment do |val|
    FlareDeploymentStatusCode.find_by_name("CURRENT") or FactoryGirl.create(:flare_deployment_status_code, :name => "CURRENT")
    FlareDeploymentStatusCode.find_by_name("PAST") or FactoryGirl.create(:flare_deployment_status_code, :name => "PAST")
  end
end