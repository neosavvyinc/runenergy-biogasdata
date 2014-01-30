FactoryGirl.define do
  factory :locations_monitor_class do |val|
  end

  factory :deluxe_locations_monitor_class, class: LocationsMonitorClass do |val|
    association :location
    association :monitor_class
  end
end