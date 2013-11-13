require "spec_helper"

describe FlareSpecification do

  let :flare_collection_statistic do
    FactoryGirl.create(:flare_collection_statistic)
  end

  let :flare_specification do
    FactoryGirl.create(:flare_specification, :flare_unique_identifier => "Jordan's Flare", :flare_collection_statistic => flare_collection_statistic)
  end

  describe "display_name" do

    it 'should return the flare_unique_identifier attribute when the display_name method is called' do
      flare_specification.display_name.should eq "Jordan's Flare"
    end

  end

  describe 'paused?' do

    it 'should return the pause property' do
      flare_specification.pause = true
      flare_specification.paused?.should be_true
    end

  end

  describe "update_statistic" do
    it 'should raise an error if the csv_file_name is blank' do
      expect {
        flare_specification.update_statistic("")
      }.to raise_error
    end

    it 'should use the existing flare_collection_statistic' do
      existing_id = flare_collection_statistic.id
      flare_specification.update_statistic("SOME_NAME", Date.today)
      flare_collection_statistic.last_csv_read.should eq "SOME_NAME"
    end

    it 'should be able to create a new flare_collection_statistic' do

    end

    it 'should set the date to the one provided' do

    end

    it 'should get the date from the csv_file_name if no date has been provided' do

    end

    it 'should set the last_csv_read to the csv_file_name provided' do

    end

    it 'should save the new flare_collection_statistic' do

    end
  end

end