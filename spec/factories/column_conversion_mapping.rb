FactoryGirl.define do
  factory :column_conversion_mapping do |val|
    sequence(:from) {|n| "from_#{n}"}
    sequence(:to) {|n| "to_#{n}"}
  end
end