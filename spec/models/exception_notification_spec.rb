require 'spec_helper'

describe ExceptionNotification do

  let :exception_notification do
    FactoryGirl.create(:exception_notification,
                       :user => FactoryGirl.create(:user, :name => 'Lemmy Kilmister'), :other_email => 'philtaylor@hotmail.com',
                       :locations_monitor_class => FactoryGirl.create(:locations_monitor_class, :location => FactoryGirl.create(:location), :monitor_class => FactoryGirl.create(:monitor_class))
    )
  end

  let :asset_column_name do
    Readings.asset_column_name
  end

  let :locations_monitor_class do
    FactoryGirl.create(:deluxe_locations_monitor_class)
  end

  let :monitor_point do
    FactoryGirl.create(:monitor_point)
  end

  let :monitor_limit do
    FactoryGirl.create(:deluxe_monitor_limit)
  end

  let :reading do
    FactoryGirl.create(:reading)
  end

  let :date_columnn_name do
    Readings.date_columnn_name
  end

  before(:each) do
    exception_notification.should_not be_nil
    ExceptionMailer.stub(:delay).and_return(ExceptionMailer)
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

  describe 'lower_limit_warning' do

    it 'should call the ExceptionMailer.monitor_limit_email' do
      expect(ExceptionMailer).to receive(:monitor_limit_email).and_return(Hashie::Mash.new({:deliver => nil}))
      exception_notification.lower_limit_warning(asset, date_time, locations_monitor_class, monitor_point, monitor_limit, reading)
    end

  end

  describe 'upper_limit_warning' do
    it 'should call the ExceptionMailer.monitor_limit_email' do
      expect(ExceptionMailer).to receive(:monitor_limit_email).and_return(Hashie::Mash.new({:deliver => nil}))
      exception_notification.lower_limit_warning(asset, date_time, locations_monitor_class, monitor_point, monitor_limit, reading)
    end
  end

  describe 'batch_lower_limit_warning' do
    it 'should call the batch_monitor_limit_email method' do
      expect(ExceptionMailer).to receive(:batch_monitor_limit_email).and_return(Hashie::Mash.new({:deliver => nil}))
      exception_notification.batch_lower_limit_warning(locations_monitor_class, [reading], [])
    end
  end

  describe 'batch_lower_limit_warning' do
    it 'should call the batch_monitor_limit_email method' do
      expect(ExceptionMailer).to receive(:batch_monitor_limit_email).and_return(Hashie::Mash.new({:deliver => nil}))
      exception_notification.batch_upper_limit_warning(locations_monitor_class, [reading], [])
    end
  end

end
