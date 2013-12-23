require 'spec_helper'

describe MonitorPoint do

  let :monitor_point do
    FactoryGirl.create(:monitor_point, :name => 'Methane Gas')
  end

  describe 'snake_name' do
    it 'should return a snake case version of the name' do
      monitor_point.snake_name.should eq('methane_gas')
    end
  end
end
