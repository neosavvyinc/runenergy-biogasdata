require 'spec_helper'

describe FtpDetail do

  let :ftp_detail do
    FactoryGirl.create(:ftp_detail)
  end

  describe 'self.file_name_as_date' do

    it 'should return fine for a csv with the date pattern' do
      FtpDetail.file_name_as_date('140319.csv').should eq(DateTime.new(2014, 03, 19))
    end

    it 'should return fine for the csv with no extension' do
      FtpDetail.file_name_as_date('140319').should eq(DateTime.new(2014, 03, 19))
    end
  end

  describe 'self.list_csv_files' do
    list = nil

    before(:each) do
      list = [
          '-rw-r--r--@ 1 trevorewen  staff   5783 Jan  7 18:14 100214.csv',
          '-rw-r--r--  1 trevorewen  staff  34039 Oct 24 14:02 groundwater_excel.xlsx',
          '-rw-r--r--@ 1 trevorewen  staff   9466 Jan  7 18:15 110214.csv',
          '-rw-r--r--@ 1 trevorewen  staff   9466 Jan  7 18:15 050214.CSV',
          '-rw-rw-rw-@ 1 trevorewen  staff  71600 Nov 20 16:14 130214.xlsx',
          '-rw-r--r--@ 1 trevorewen  staff   8352 Jan  2 22:12 090214.csv'
      ]
    end

    it 'should raise an error if passed nil' do
      expect {
        FtpDetail.list_csv_files(nil)
      }.to raise_error
    end

    it 'should select only the CSVs from the list (including capital CSV)' do
      FtpDetail.list_csv_files(list).each do |f|
        (f[:file].include?('.csv') || f[:file].include?('.CSV')).should be_true
      end
    end

    it 'should sort by the date' do
      FtpDetail.list_csv_files(list).should eq([{:file => '050214.CSV', :date => DateTime.new(2005, 02, 14)},
                                                {:file => '090214.csv', :date => DateTime.new(2009, 02, 14)},
                                                {:file => '100214.csv', :date => DateTime.new(2010, 02, 14)},
                                                {:file => '110214.csv', :date => DateTime.new(2011, 02, 14)}])
    end
  end

  describe 'before_create' do

    describe 'defaults' do

      it 'should set the folder_path to a default of /DATA' do
        FtpDetail.create.folder_path.should eq('/DATA')
      end

      it 'should be able to override the default folder path on initialization' do
        FtpDetail.create(:folder_path => '/OTHER_DATA').folder_path.should eq('/OTHER_DATA')
      end

    end

  end

  describe 'import' do

  end

  describe 'import_file' do

    it 'should raise an error if the file is blank' do
      expect {
        ftp_detail.import_file({}, nil)
      }.to raise_error
    end

  end

end
