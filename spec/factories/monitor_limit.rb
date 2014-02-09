FactoryGirl.define do
  factory :monitor_limit do |val|

  end

  factory :deluxe_monitor_limit, class: MonitorLimit do |val|
    sequence(:lower_limit) {|n| 200 + n}
    sequence(:upper_limit) {|n| 800 + n}
  end
end