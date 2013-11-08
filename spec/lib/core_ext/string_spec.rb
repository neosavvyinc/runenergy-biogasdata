require 'spec_helper'

describe String do

  describe 'nan?' do

    it 'should return true with a string that is nan' do
      "Mike Tyson".nan?.should be_true
    end

    it 'should return false with an int' do
      "18".nan?.should be_false
    end

    it 'should return false with a float' do
      "0.679".nan?.should be_false
    end

    it 'should return false with a negative float' do
      "-0.679".nan?.should be_false
    end

    it 'should return true for empty' do
      "".nan?.should be_true
    end

    it 'should return true for blank spaces' do
      " ".nan?.should be_true
    end

  end

end