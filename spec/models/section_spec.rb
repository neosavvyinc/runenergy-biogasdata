require 'spec_helper'

describe Section do

  let :location do
    FactoryGirl.create(:location, :site_name => 'Waco')
  end

  let :section do
    FactoryGirl.create(:section, :name => 'Area 54')
  end

  describe 'self.lazy_load' do

    it 'should create a section unique to a location and a name' do
      Section.lazy_load(:name => 'My House', :location_id => FactoryGirl.create(:location).id).should eq(Section.last)
    end

    it 'should grab a section from the db if it already exists on the location at that name' do
      location = FactoryGirl.create(:location)
      section = FactoryGirl.create(:section, :location => location, :name => 'Josies Bar')
      Section.lazy_load(:name => 'Josies Bar', :location_id => location.id).should eq(section)
    end

    it 'should not re-use a section with the same name at another location' do
      location = FactoryGirl.create(:location)
      other_location = FactoryGirl.create(:location)
      section = FactoryGirl.create(:section, :location => location, :name => 'Josies Bar')
      Section.lazy_load(:name => 'Josies Bar', :location_id => other_location.id).should_not eq(section)
    end

    it 'should not re-use a section at the same location with another name' do
      location = FactoryGirl.create(:location)
      section = FactoryGirl.create(:section, :location => location, :name => 'Josies Bar')
      Section.lazy_load(:name => 'Jims Bar', :location_id => location.id).should_not eq(section)
    end
    
  end
  
  describe 'display_name' do
    it 'should return No location specified - + name if no location is specified' do
      section.display_name.should eq('No Location Specified - Area 54')
    end

    it 'should return location.site_name - name when location is specified' do
      section.location = location
      section.save
      section.display_name.should eq('Waco - Area 54')
    end
  end
  
end