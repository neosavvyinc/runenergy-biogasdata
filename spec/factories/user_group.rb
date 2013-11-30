FactoryGirl.define do
  factory :user_group do |val|
    sequence(:name) { |n| "MY GROUP #{n}" }
  end
end