require 'spec_helper'

describe FieldLog do

  let :field_log do
    FactoryGirl.create(:field_log)
  end

  describe 'as_json' do

    it 'should merge a json parsed version of the data with the normal properties' do
      json = field_log.as_json
      json.should_not be_nil
      json['data']['name'].should_not be_nil
      json['data']['name'].should_not eq('')
    end
    
  end
end
