FactoryGirl.define do
  factory :asset do |val|

    sequence(:unique_identifier) {|n| "UID#{n}"}

    before :create do |asset|
      if asset.monitor_class.nil?
        asset.monitor_class = FactoryGirl.create(:monitor_class)
      end
    end

  end
end