require 'spec_helper'

describe FieldLogPoint do

  let :field_log_point do
    FactoryGirl.create(:field_log_point, :name => 'Favorite Food')
  end

  describe 'self.RAIN_SINCE_PREVIOUS_READING' do

    it 'should create a new one if it does not exist' do
      FieldLogPoint.RAIN_SINCE_PREVIOUS_READING.id.should_not eq(field_log_point)
    end

    it 'should return the existing if it exists' do
      my_field_log_point = FactoryGirl.create(:field_log_point, :name => 'Rain Since Previous Reading')
      FieldLogPoint.RAIN_SINCE_PREVIOUS_READING.id.should eq(my_field_log_point.id)
    end

  end

  describe 'snake_name' do

    it 'should convert the name to a lower case and snakecase version' do
      field_log_point.snake_name.should eq('favorite_food')
    end
    
  end

  describe 'as_json' do
    it 'should include the :snake_name method in the hash' do
      field_log_point.as_json[:snake_name].should eq('favorite_food')
    end
  end

end