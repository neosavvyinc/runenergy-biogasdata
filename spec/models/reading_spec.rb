require 'spec_helper'

describe Reading do

  describe 'self.process_csv' do

    it 'should raise an error if passed a blank file parameter' do
      expect {
        Reading.process_csv(nil)
      }.to raise_error
    end

  end

end