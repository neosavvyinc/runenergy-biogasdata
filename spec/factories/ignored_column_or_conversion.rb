FactoryGirl.define do
  factory :ignored_column_or_conversion do |val|
    sequence(:column_name) {|n| "COLUMN #{n}"}
    sequence(:convert_to) {|n| "CONVERSION #{n}"}
  end
end