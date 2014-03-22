require 'spec_helper'

describe ExceptionMailer do

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @reading = Factory.create(:reading)
    @locations_monitor_class = FactoryGirl.create(:deluxe_locations_monitor_class)
    @monitor_point = FactoryGirl.create(:monitor_point)
    ExceptionMailer.monitor_limit_email(locations_monitor_class, )
  end

  describe :monitor_limit_email do
    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end
  end
end