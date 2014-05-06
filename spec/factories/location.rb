FactoryGirl.define do
  factory :location do |val|
    sequence(:site_name) {|n| "Site Named #{n}"}
  end

  factory :deluxe_location, :class => Location do |l|
    sequence(:site_name) {|n| "Site Named #{n}"}
  end
end