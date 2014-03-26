FactoryGirl.define do
  factory :monitor_point do |val|

  end

  factory :deluxe_monitor_point, class: MonitorPoint do |val|
    sequence(:name) {|n| "Monitor Point #{n}"}
    sequence(:unit) {|n| "Unit #{n}"}
  end
end