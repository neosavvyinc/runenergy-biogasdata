require 'spec_helper'

describe IgnoredColumnOrConversion do

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :ignored_column_or_conversion do
    FactoryGirl.create(:ignored_column_or_conversion)
  end

  describe 'self.process' do

    it 'should just return the nil if the data is nil' do
      IgnoredColumnOrConversion.process(nil, monitor_class.id).should be_nil
    end

    it 'should just return the data if the monitor_class_id is nil' do
      IgnoredColumnOrConversion.process({'name' => 'Lemmy'}, nil).should eq({'name' => 'Lemmy'})
    end

    it 'should remove an ignored column' do
      ignored_column_or_conversion.update_attributes(:ignore => true, :column_name => 'name')
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'age' => 65})
    end

    it 'should map over values from a converted column with no mappings' do
      ignored_column_or_conversion.update_attributes(:column_name => 'name', :convert_to => 'title')
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'title' => 'Lemmy', 'age' => 65})
    end

    it 'should map over values from a converted column with mappings' do
      ignored_column_or_conversion.update_attributes(:column_name => 'name', :convert_to => 'name')
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.column_conversion_mappings << FactoryGirl.create(:column_conversion_mapping, :from => 'Lemmy', :to => 'Ronnie')
      ignored_column_or_conversion.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'name' => 'Ronnie', 'age' => 65})
    end

    it 'should be able to apply new comments to the data node ' do
      ignored_column_or_conversion.update_attributes(:column_name => 'name', :convert_to => nil)
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.column_conversion_mappings << FactoryGirl.create(:column_conversion_mapping, :from => 'Lemmy', :comment_entry => 'King of metal.')
      ignored_column_or_conversion_b = FactoryGirl.create(:ignored_column_or_conversion, :column_name => 'age', :convert_to => nil)
      ignored_column_or_conversion_b.monitor_classes << monitor_class
      ignored_column_or_conversion_b.column_conversion_mappings << FactoryGirl.create(:column_conversion_mapping, :from => '65', :comment_entry => 'Is old.')
      ignored_column_or_conversion.save
      ignored_column_or_conversion_b.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'name' => 'Lemmy', 'age' => 65, 'Comments' => 'King of metal. Is old.'})
    end

    it 'should be able to use a column_name with no covert_to for conversions' do
      ignored_column_or_conversion.update_attributes(:column_name => 'name', :convert_to => nil)
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.column_conversion_mappings << FactoryGirl.create(:column_conversion_mapping, :from => 'Lemmy', :to => 'Ronnie')
      ignored_column_or_conversion.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'name' => 'Ronnie', 'age' => 65})
    end

    it 'should be able to use a column_name with no convert_to for comments' do
      ignored_column_or_conversion.update_attributes(:column_name => 'name', :convert_to => nil)
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.column_conversion_mappings << FactoryGirl.create(:column_conversion_mapping, :from => 'Lemmy', :comment_entry => 'Dude wheres my car?')
      ignored_column_or_conversion.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'name' => 'Lemmy', 'age' => 65, 'Comments' => 'Dude wheres my car?'})
    end

    it 'should be able to do an ignore with comments added' do
      ignored_column_or_conversion.update_attributes(:column_name => 'name', :convert_to => nil, :ignore => true)
      ignored_column_or_conversion.monitor_classes << monitor_class
      ignored_column_or_conversion.column_conversion_mappings << FactoryGirl.create(:column_conversion_mapping, :from => 'Lemmy', :comment_entry => 'Dude wheres my car?')
      ignored_column_or_conversion.save

      IgnoredColumnOrConversion.process({'name' => 'Lemmy', 'age' => 65}, monitor_class.id).should eq({'age' => 65, 'Comments' => 'Dude wheres my car?'})
    end

  end

  describe 'column_value_map' do

    it 'should return nil if there are no column_conversion_mappings_defined' do
      ignored_column_or_conversion.column_value_map.should be_nil
    end

    it 'should return a map of the column_conversion_mappings from, to values' do
      map_1 = FactoryGirl.create(:column_conversion_mapping)
      map_2 = FactoryGirl.create(:column_conversion_mapping)
      ignored_column_or_conversion.column_conversion_mappings << map_1
      ignored_column_or_conversion.column_conversion_mappings << map_2
      ignored_column_or_conversion.column_value_map.should eq({
                                                                  map_1.from => map_1.to, map_2.from => map_2.to
                                                              })
    end

  end

  describe 'comment_value_map' do

    it 'should return nil if there are no column_conversion_mappings_defined' do
      ignored_column_or_conversion.comment_value_map.should be_nil
    end

    it 'should return a map of the column_conversion_mappings from, to values' do
      map_1 = FactoryGirl.create(:column_conversion_mapping, :comment_entry => 'Steely Dan.')
      map_2 = FactoryGirl.create(:column_conversion_mapping, :comment_entry => 'Motorhead.')
      ignored_column_or_conversion.column_conversion_mappings << map_1
      ignored_column_or_conversion.column_conversion_mappings << map_2
      ignored_column_or_conversion.comment_value_map.should eq({
                                                                  map_1.from => 'Steely Dan.', map_2.from => 'Motorhead.'
                                                              })
    end

  end

  describe 'display_name' do

    it 'should return None Specified when there is no column name' do
      ignored_column_or_conversion.column_name = nil
      ignored_column_or_conversion.display_name.should eq('None specified')
    end

    it 'should just return the column name if there is no convert_to' do
      ignored_column_or_conversion.convert_to = nil
      ignored_column_or_conversion.display_name.should eq(ignored_column_or_conversion.column_name)
    end

    it 'should return the display_name as computed from the column_name to the convert_to value' do
      ignored_column_or_conversion.display_name.should eq("#{ignored_column_or_conversion.column_name} > #{ignored_column_or_conversion.convert_to}")
    end

  end

end