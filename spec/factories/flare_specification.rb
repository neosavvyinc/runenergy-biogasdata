FactoryGirl.define do
  factory :flare_specification do |val|
    sequence(:flare_unique_identifier) {|n| "FL-G-#{n}"}
  end
end