require 'spec_helper'

describe IgnoredColumnOrConversion do

  let :ignored_column_or_conversion do
    FactoryGirl.create(:ignored_column_or_conversion)
  end

  describe 'display_name' do

    it 'should return None Specified when there is no column name' do
      ignored_column_or_conversion.column_name = nil
      ignored_column_or_conversion.display_name.should eq('None specified')
    end

    it 'should return the display_name as computed from the column_name to the convert_to value' do
      ignored_column_or_conversion.display_name.should eq("#{ignored_column_or_conversion.column_name} > #{ignored_column_or_conversion.convert_to}")
    end

  end

end
