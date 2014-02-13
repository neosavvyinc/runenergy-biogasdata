FactoryGirl.define do
  factory :asset_property_value do |val|
    sequence(:value) {|n| n * 100}
  end
end