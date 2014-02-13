FactoryGirl.define do
  factory :custom_monitor_calculation do |val|
    sequence(:name) {|n| "Calculation #{n}"}
    sequence(:value) {|n| "#{n} + #{n} * #{n * 2}"}
  end
end