FactoryGirl.define do
  factory :ftp_import_log do |val|
    association :ftp_detail
  end
end