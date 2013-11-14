FactoryGirl.define do
  factory :monitor_class do |val|
    sequence(:name) {|n| "MY CLASS #{n}"}
  end
end