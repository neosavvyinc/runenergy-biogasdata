require 'spec_helper'

describe HeatMapDetail do

  describe 'self.asset_map' do
    let :locations_monitor_class do
      FactoryGirl.create(:deluxe_locations_monitor_class)
    end

    before(:each) do
      10.times do
        FactoryGirl.create(:asset, :location => locations_monitor_class.location, :monitor_class => locations_monitor_class.monitor_class)
      end
      5.times do
        FactoryGirl.create(:asset, :location => locations_monitor_class.location)
      end
      3.times do
        FactoryGirl.create(:asset, :monitor_class => locations_monitor_class.monitor_class)
      end
    end

    it 'should return all the assets for a locations_monitor_class' do
      asset_rows = HeatMapDetail.asset_map(:locations_monitor_class => locations_monitor_class)
      asset_rows.size.should eq(10)
    end

    it 'should be able to return all the assets for a location and a monitor_class mapped to rows' do
      asset_rows = HeatMapDetail.asset_map(:location => locations_monitor_class.location, :monitor_class => locations_monitor_class.monitor_class)
      asset_rows.size.should eq(10)
    end

  end

  describe 'self.asset_row' do

    let :asset do
      FactoryGirl.create(:asset, :heat_map_detail => FactoryGirl.create(:heat_map_detail), :unique_identifier => '25OR624')
    end

    it 'should have an id in the json structure' do
      HeatMapDetail.asset_row(asset)[:id].should eq(asset.id)
    end

    it 'should have a uid in the json structure' do
      HeatMapDetail.asset_row(asset)[:uid].should eq(asset.unique_identifier)
    end

    it 'should have an x in the json structure' do
      HeatMapDetail.asset_row(asset)[:x].should eq(asset.heat_map_detail.x)
    end

    it 'should have an y in the json structure' do
      HeatMapDetail.asset_row(asset)[:y].should eq(asset.heat_map_detail.y)
    end
  end

  describe 'self.reading_map' do

    let :locations_monitor_class do
      FactoryGirl.create(:deluxe_locations_monitor_class)
    end

    let :monitor_point do
      FactoryGirl.create(:monitor_point, :name => 'Urethane')
    end

    before(:each) do
      7.times do
        FactoryGirl.create(:reading, :data => {'Urethane' => rand(100)}, :asset =>
            FactoryGirl.create(:asset, :location => locations_monitor_class.location, :monitor_class => locations_monitor_class.monitor_class))
      end
      6.times do
        FactoryGirl.create(:reading, :data => {'Urethane' => rand(100)}, :asset =>
            FactoryGirl.create(:asset, :location => locations_monitor_class.location))
      end
      2.times do
        FactoryGirl.create(:reading, :data => {'Urethane' => rand(100)}, :asset =>
            FactoryGirl.create(:asset, :monitor_class => locations_monitor_class.monitor_class))
      end
    end

    it 'should return a reading row for each asset in the locations_monitor_class' do
      HeatMapDetail.reading_map(:locations_monitor_class => locations_monitor_class, :monitor_point => monitor_point).size.should eq(7)
    end

    it 'should return a reading row for each asset in the location and monitor_class' do
      HeatMapDetail.reading_map(
          :location => locations_monitor_class.location,
          :monitor_class => locations_monitor_class.monitor_class,
          :monitor_point => monitor_point)
      .size.should eq(7)
    end

  end

  describe 'self.reading_row' do

    let :asset do
      FactoryGirl.create(:asset, :heat_map_detail => FactoryGirl.create(:heat_map_detail), :unique_identifier => '25OR624')
    end

    let :monitor_point do
      FactoryGirl.create(:monitor_point, :name => 'Methane')
    end

    before(:each) do
      FactoryGirl.create(:reading, :asset => asset, :data => {'Methane' => 17}, :taken_at => DateTime.new(2010, 9, 15))
      FactoryGirl.create(:reading, :asset => asset, :data => {'Methane' => 82.5}, :taken_at => DateTime.new(2010, 10, 15))
      FactoryGirl.create(:reading, :asset => asset, :data => {'Methane' => 26}, :taken_at => DateTime.new(2010, 11, 15))
    end

    it 'should include the x in the json structure' do
      HeatMapDetail.reading_row(asset, monitor_point)[:x].should eq(asset.heat_map_detail.x)
    end

    it 'should include the y in the json structure' do
      HeatMapDetail.reading_row(asset, monitor_point)[:y].should eq(asset.heat_map_detail.y)
    end

    it 'should be able to return an average of all the readings of the monitor point for the asset in the count prop' do
      HeatMapDetail.reading_row(asset, monitor_point)[:count].should eq('41.83')
    end

    it 'should be able to take a start date only' do
      HeatMapDetail.reading_row(asset, monitor_point, DateTime.new(2010, 10, 15))[:count].should eq('54.25')
    end

    it 'should be able to take an end date only' do
      HeatMapDetail.reading_row(asset, monitor_point, nil, DateTime.new(2010, 9, 15))[:count].should eq('17.00')
    end

    it 'should be able to take both a start and end date' do
      HeatMapDetail.reading_row(asset, monitor_point, DateTime.new(2010, 10, 15), DateTime.new(2010, 10, 15))[:count].should eq('82.50')
    end

  end

end
