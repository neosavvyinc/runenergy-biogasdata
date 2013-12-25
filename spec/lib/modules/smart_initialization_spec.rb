require 'spec_helper'

describe SmartInitialization do

  describe 'new_ignore_unknown' do
    it 'should be able instantiate objects with known properties' do
      fmd = FlareMonitorData.new_ignore_unknown(:blower_speed => 92)
      fmd.save

      fmd.blower_speed.should eq(92)
    end

    it 'should ignore unknown properties' do
      fmd = FlareMonitorData.new_ignore_unknown(:blower_speed => 92, :unknown_property => 'Hello')
      fmd.save

      fmd.blower_speed.should eq(92)
    end
  end

end