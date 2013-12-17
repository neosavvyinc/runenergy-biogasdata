FactoryGirl.define do
  factory :asset do |val|

    before :create do |asset|
      if asset.monitor_classes.empty?
        asset.monitor_classes << FactoryGirl.create(:monitor_class)
      end
    end

  end
end