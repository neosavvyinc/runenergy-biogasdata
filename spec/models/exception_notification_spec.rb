require 'spec_helper'

describe ExceptionNotification do

  let :exception_notification do
    FactoryGirl.create(:exception_notification,
                       :user => FactoryGirl.create(:user, :name => 'Lemmy Kilmister'), :other_email => 'philtaylor@hotmail.com',
                       :locations_monitor_class => FactoryGirl.create(:locations_monitor_class, :location => FactoryGirl.create(:location), :monitor_class => FactoryGirl.create(:monitor_class))
    )
  end

  before(:each) do
    exception_notification.should_not be_nil
  end

  describe 'display_name' do
    it 'should return the user.name if that is defined' do
      exception_notification.display_name.should eq('Lemmy Kilmister')
    end

    it 'should return the other_email if no user.name is defined' do
      exception_notification.user = nil
      exception_notification.display_name.should eq('philtaylor@hotmail.com')
    end

    it 'should return nil if neither value is defined' do
      exception_notification.user = nil
      exception_notification.other_email = nil
      exception_notification.display_name.should be_nil
    end
  end
  
end
