require 'spec_helper'

describe FlareDeployment do

  let :flare_specification do
    FactoryGirl.create(:flare_specification)
  end

  let :flare_deployment do
    FactoryGirl.create(:flare_deployment, :flare_specification => flare_specification)
  end

  describe 'current?' do
    it 'should return false if the flare_deployment_status_code is not current' do
      flare_deployment.flare_deployment_status_code = FlareDeploymentStatusCode.find_by_name("PAST")
      flare_deployment.current?.should be_false
    end

    it 'should return true when the flare_deployment_status_code is current' do
      flare_deployment.flare_deployment_status_code = FlareDeploymentStatusCode.find_by_name("CURRENT")
      flare_deployment.current?.should be_true
    end
  end

  describe 'apply_unique_identifier' do

    before(:each) do
      flare_specification.flare_unique_identifier = 'killed_by_death'
    end

    it 'should create a combination of the unique identifier of the flare specification and its own id' do
      flare_deployment.apply_unique_identifier
      flare_deployment.client_flare_unique_identifier.should eq "killed_by_death-#{flare_deployment.id}"
    end

    it 'should save the attribute to the db' do
      flare_deployment.apply_unique_identifier
      db_fd = FlareDeployment.find(flare_deployment.id)
      db_fd.client_flare_unique_identifier.should eq "killed_by_death-#{flare_deployment.id}"
    end

  end

  describe 'apply_deployment_status' do

    it 'should set the flare_deployment_status to current if the last reading is blank' do
      flare_deployment.apply_deployment_status
      flare_deployment.flare_deployment_status_code.should eq FlareDeploymentStatusCode.CURRENT
    end

    it 'should set the flare_deployment_status to past if the last reading is not blank' do
      flare_deployment.last_reading = Date.new
      flare_deployment.save
      flare_deployment.apply_deployment_status
      flare_deployment.flare_deployment_status_code.should eq FlareDeploymentStatusCode.PAST
    end

  end

  describe 'min_date' do

    before(:each) do
      flare_deployment.first_reading = Date.parse("31-10-2010")
      flare_deployment.save
    end

    it 'should return the first_reading property if the date_time is blank' do
      flare_deployment.min_date(nil).should eq Date.parse("31-10-2010")
    end

    it 'should return the date_time if the first_reading is blank' do
      flare_deployment.first_reading = nil
      flare_deployment.min_date(Date.parse('18-09-2007')).should eq Date.parse('18-09-2007')
    end

    it 'should return the max between the date_time and the first_reading if both are set' do
      flare_deployment.min_date(Date.parse('18-09-2007')).should eq Date.parse("31-10-2010")
    end

    it 'should return the max in the reverse case' do
      flare_deployment.min_date(Date.parse('18-09-2011')).should eq Date.parse('18-09-2011')
    end

  end

  describe 'max_date' do
    before(:each) do
      flare_deployment.last_reading = Date.parse("31-10-2010")
      flare_deployment.save
    end

    it 'should return the date_time passed in if the last_reading is blank' do
      flare_deployment.last_reading = nil
      flare_deployment.max_date(Date.parse("13-08-2009")).should eq Date.parse("13-08-2009")
    end

    it 'should return the last reading + a day minus a minute if the passed in date_time is blank' do
      max_date = flare_deployment.max_date(nil)
      max_date.year.should eq 2010
      max_date.month.should eq 10
      max_date.day.should eq 31
      max_date.hour.should eq 23
      max_date.min.should eq 59
    end

    it 'should return the minimum of the last_reading plus a day minus a minute vs. the date_time passed in' do
      max_date = flare_deployment.max_date(Date.parse("30-10-2010"))
      max_date.year.should eq 2010
      max_date.month.should eq 10
      max_date.day.should eq 30
      max_date.hour.should eq 0
      max_date.min.should eq 0
    end

    it 'should return the reverse of the prior minimum' do
      max_date = flare_deployment.max_date(Date.parse("01-11-2010"))
      max_date.year.should eq 2010
      max_date.month.should eq 10
      max_date.day.should eq 31
      max_date.hour.should eq 23
      max_date.min.should eq 59
    end
  end

end