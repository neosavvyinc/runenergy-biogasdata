require "spec_helper"

describe FlareMonitorData do

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

  describe "self" do
    describe "with_filters" do
      it 'should return the original query if no filters are passed in' do
        query = FlareMonitorData.all
        FlareMonitorData.with_filters(query).should eq(query)
      end

      it 'should return the original query if empty filters are passed in' do
        query = FlareMonitorData.all
        FlareMonitorData.with_filters(query, {}).should eq(query)
      end

      it 'should match the filters to the columns' do
        query = FlareMonitorData.with_filters(FlareMonitorData, {:blower_speed => "> -1", :lfg_temperature => "<= 7"})
        query.length.should eq(1)
        query.first.should eq(flare_data_c)
      end
    end
  end

end