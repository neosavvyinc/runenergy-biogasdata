require 'spec_helper'

describe FieldLogPoint do

  let :field_log_point do
    FactoryGirl.create(:field_log_point, :name => 'Favorite Food')
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