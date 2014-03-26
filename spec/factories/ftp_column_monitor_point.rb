FactoryGirl.define do
  factory :ftp_column_monitor_point do |val|
    sequence(:column_name) {|n| "Column #{n}"}
    association :monitor_point, :factory => [:deluxe_monitor_point]
    association :ftp_detail
  end
end