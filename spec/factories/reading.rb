FactoryGirl.define do
  factory :reading do |val|
    sequence(:data) {|n| "{\"index\": \"#{n}\"} "}
  end
end