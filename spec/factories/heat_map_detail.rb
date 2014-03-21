FactoryGirl.define do
  factory :heat_map_detail do |val|
    sequence(:x) {|n| rand(1..200)}
    sequence(:y) {|n| rand(1..200)}
  end
end