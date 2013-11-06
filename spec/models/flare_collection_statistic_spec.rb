require "spec_helper"

describe FlareCollectionStatistic do

  let :flare_specification do
    FactoryGirl.create(:flare_specification, :flare_unique_identifier => "Robots Counterfeiting Money")
  end

  let :flare_collection_statistic do
    FactoryGirl.create(:flare_collection_statistic, :flare_specification => flare_specification)
  end

  describe "display_name" do
    it 'should return the flare_unique_identifier for the flare_specification' do
      flare_collection_statistic.display_name.should eq "Robots Counterfeiting Money"
    end
  end
  
end