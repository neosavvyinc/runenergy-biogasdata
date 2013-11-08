FactoryGirl.define do
  factory :user_type do |val|

  end
  factory :user do |val|
    sequence(:email) {|n| "some-dude-#{n}@gmail.com"}
    sequence(:password) {|n| "whatsmynumber#{n}"}

    UserType.OVERSEER or FactoryGirl.create(:user_type, :name => "OVERSEER")
    UserType.CUSTOMER or FactoryGirl.create(:user_type, :name => "CUSTOMER")
  end
end