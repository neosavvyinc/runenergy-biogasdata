FactoryGirl.define do
  factory :ftp_detail do |val|
    sequence(:url) {|n| "ftp://url.#{n.to_s}"}
    sequence(:username) {|n| "username_#{n.to_s}"}
    sequence(:password) {|n| "password_#{n.to_s}"}
    association :asset
  end
end