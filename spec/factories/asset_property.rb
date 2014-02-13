FactoryGirl.define do
  factory :asset_property do |val|
    sequence(:name) {|n| "Property Name #{n}"}
  end
end