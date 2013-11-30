FactoryGirl.define do
  factory :device_profile do |val|
    sequence(:name) { |n| "MY PROFILE #{n}" }
  end
end