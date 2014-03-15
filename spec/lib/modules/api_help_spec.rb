require 'spec_helper'

describe ApiHelp do

  include ApiHelp

  describe 'ids_names_as_array' do

    it 'should return an array with a single id if passed a single id and class_def' do
      ids_names_as_array('6', MonitorClass).should eq([6])
    end

    it 'should return an array of multiple ids if passed comma separated ids and a class_def' do
      ids_names_as_array('6,8,19', MonitorClass).should eq([6,8,19])
    end

    it 'should play nice with id separations that need to be stripped' do
      ids_names_as_array('6, 1, 29', Location).should eq([6,1,29])
    end

    it 'should work with a combo of ids and names' do
      monitor_class = FactoryGirl.create(:monitor_class, :name => 'Methane Future')
      ids_names_as_array('2, Methane Future, 5', MonitorClass).should eq([2,monitor_class.id,5])
    end

    it 'should work fine with just names' do
      monitor_class = FactoryGirl.create(:monitor_class, :name => 'Methane Future')
      other_monitor_class = FactoryGirl.create(:monitor_class, :name => 'Bob')
      ids_names_as_array('Methane Future, Bob', MonitorClass).should eq([monitor_class.id, other_monitor_class.id])
    end

    it 'should return nil in cases where a name is not found' do
      monitor_class = FactoryGirl.create(:monitor_class, :name => 'Methane Future')
      other_monitor_class = FactoryGirl.create(:monitor_class, :name => 'Bob')
      ids_names_as_array('Methane Future, Bob, George', MonitorClass).should eq([monitor_class.id, other_monitor_class.id, nil])
    end

    it 'should be able to specify property names other than name' do
      location = FactoryGirl.create(:location, :site_name => 'Mount Trashmore')
      ids_names_as_array('Mount Trashmore', Location, 'site_name')
    end

  end

end