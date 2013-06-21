require 'spec_helper'

describe FlareMonitorDataQueryBuilder do

  let :flare_data_a do
    FactoryGirl.create(:flare_monitor_data, :blower_speed => -1, :lfg_temperature => 47.76)
  end

  let :flare_data_b do
    FactoryGirl.create(:flare_monitor_data, :blower_speed => 2, :lfg_temperature => 10050.23)
  end

  let :flare_data_c do
    FactoryGirl.create(:flare_monitor_data, :blower_speed => 0, :lfg_temperature => 6)
  end

  before(:each) do
    flare_data_a.should_not be_nil
    flare_data_b.should_not be_nil
    flare_data_c.should_not be_nil
  end

  describe "where_filter" do

    it 'should should return itself' do
      builder = FlareMonitorDataQueryBuilder.new
      builder.where_filter(:blower_speed, "< 3").should eq(builder)
    end

    it 'should be able to make and return a query with a single statement' do
      query = FlareMonitorDataQueryBuilder.new.where_filter(:blower_speed, "< 3").query
      query.length.should eq(3)
    end

    it 'should play nice with equal queries' do
      query = FlareMonitorDataQueryBuilder.new.where_filter(:blower_speed, "= -1").query
      query.length.should eq(1)
      query.first.should eq(flare_data_a)
    end

    it 'should play nice with greater than queries' do
      query = FlareMonitorDataQueryBuilder.new.where_filter(:lfg_temperature, ">1000").query
      query.length.should eq(1)
      query.first.should eq(flare_data_b)
    end

    it 'should play nice with less than queries' do
      query = FlareMonitorDataQueryBuilder.new.where_filter(:lfg_temperature, "< 7.56").query
      query.length.should eq(1)
      query.first.should eq(flare_data_c)
    end

    it 'should play nice with greater than or equal to queries' do
      query = FlareMonitorDataQueryBuilder.new.where_filter(:lfg_temperature, " >= 40").query
      query.length.should eq(2)
      query.each do |fmd|
        (fmd == flare_data_a or fmd == flare_data_b).should be_true
      end
    end

    it 'should play nice with less than or equal to queries' do
      query = FlareMonitorDataQueryBuilder.new.where_filter(:blower_speed, "<= 0").query
      query.length.should eq(2)
      query.each do |fmd|
        (fmd == flare_data_a or fmd == flare_data_c).should be_true
      end
    end

    it 'should be able to chain queries' do
      query = FlareMonitorDataQueryBuilder.new.
          where_filter(:lfg_temperature, "> 7.56").
          where_filter(:blower_speed, "> -1").
          query
      query.length.should eq(1)
      query.first.should eq(flare_data_b)
    end

  end

end