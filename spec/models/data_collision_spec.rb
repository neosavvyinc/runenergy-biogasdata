require 'spec_helper'

describe DataCollision do

  describe 'self.create_if_collision' do
    reading_a = nil, reading_b = nil, reading_c = nil, asset = nil, taken_at = nil
    before(:each) do
      asset = FactoryGirl.create(:asset)
      taken_at = DateTime.now
      reading_a = FactoryGirl.create(:reading, :asset => asset, :taken_at => taken_at)
      reading_b = FactoryGirl.create(:reading, :asset => asset, :taken_at => taken_at)
      reading_c = FactoryGirl.create(:reading, :asset => asset, :taken_at => taken_at)
    end

    it 'should return nil if there is no collision' do
      DataCollision.create_if_collision(FactoryGirl.create(:reading, :asset => FactoryGirl.create(:asset), :taken_at => DateTime.now)).should be_nil
    end

    it 'should create a DataCollision' do
      dc = DataCollision.create_if_collision(reading_b)
      dc.id.should_not be_nil
    end

    it 'should create a DataCollision with all the collisions added' do
      dc = DataCollision.create_if_collision(reading_b)
      dc.readings.size.should eq(3)
      dc.readings.include?(reading_a).should be_true
      dc.readings.include?(reading_b).should be_true
      dc.readings.include?(reading_c).should be_true
    end

    it 'should not create it if it already exists with the readings involved' do
      collisions = DataCollision.create_if_collision(reading_a)
      collisions_b = DataCollision.create_if_collision(reading_c)
      collisions.id.should eq(collisions_b.id)
    end

  end

  describe 'self.collisions' do
    reading_a = nil, reading_b = nil, asset = nil, taken_at = nil
    before(:each) do
      asset = FactoryGirl.create(:asset)
      taken_at = DateTime.now
      reading_a = FactoryGirl.create(:reading, :asset => asset, :taken_at => taken_at)
      reading_b = FactoryGirl.create(:reading, :asset => asset, :taken_at => taken_at)
    end

    it 'should be able to return a collision for new elements without an id' do
      DataCollision.collisions(Reading.new(:taken_at => taken_at, :asset_id => asset.id)).size.should eq(2)
    end

    it 'should return an empty array if there are no collisions' do
      DataCollision.collisions(FactoryGirl.create(:reading, :asset => FactoryGirl.create(:asset), :taken_at => DateTime.now)).should eq([])
    end

    it 'should return a single collision in an array if there is one' do
      collisions = DataCollision.collisions(reading_a)
      collisions.size.should eq(1)
      collisions[0].should eq(reading_b)
    end

    it 'should return multiple collisions in an array if there are multiple' do
      reading_c = FactoryGirl.create(:reading, :asset => asset, :taken_at => taken_at)
      collisions = DataCollision.collisions(reading_a)
      collisions.size.should eq(2)
      collisions[0].should eq(reading_b)
      collisions[1].should eq(reading_c)
    end

    it 'should return an empty array if there is no asset_id' do
      FactoryGirl.create(:reading, :taken_at => taken_at)
      FactoryGirl.create(:reading, :taken_at => taken_at)
      DataCollision.collisions(FactoryGirl.create(:reading, :taken_at => taken_at)).should eq([])
    end

    it 'should return an empty array if there is no taken_at' do
      FactoryGirl.create(:reading, :asset => asset)
      FactoryGirl.create(:reading, :asset => asset)
      DataCollision.collisions(FactoryGirl.create(:reading, :asset => asset)).should eq([])
    end

  end

  describe 'display_name' do

    it 'should return No Readings in cases of a data collision with no readings' do
      FactoryGirl.create(:data_collision).display_name.should eq('No Readings')
    end

    it 'should return a name containing details from the first reading' do
      taken_at = DateTime.now
      dc = FactoryGirl.create(:data_collision)
      dc.readings << FactoryGirl.create(:reading, :taken_at => taken_at, :asset => FactoryGirl.create(:asset, :unique_identifier => '25OR624'))
      dc.display_name.include?('25OR624').should be_true
    end
    
  end
  
end
