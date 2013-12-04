FactoryGirl.define do
  factory :field_log do |val|
    sequence(:data) { |n| '{"name": "Name ' + n.to_s + '"}' }
  end
end