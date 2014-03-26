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

  describe 'after_initialize' do

    describe 'defaults' do

      describe 'folder_path' do
        it 'should set the folder_path to a default of /DATA' do
          FtpDetail.new.folder_path.should eq('/DATA')
        end

        it 'should be able to override the default folder path on initialization' do
          FtpDetail.new(:folder_path => '/OTHER_DATA').folder_path.should eq('/OTHER_DATA')
        end
      end

      describe 'date_column_name' do
        it 'should defaut to Date if not provided' do
          FtpDetail.new.date_column_name.should eq('Date')
        end

        it 'should use the provided value in the other case' do
          FtpDetail.new(:date_column_name => 'Date Time Other').date_column_name.should eq('Date Time Other')
        end
      end
      
      describe 'time_column_name' do

        it 'should default to time if not provided' do
          FtpDetail.new.time_column_name.should eq('Time')
        end

        it 'should use the provided value in the other case' do
          FtpDetail.new(:time_column_name => 'Time Other').time_column_name.should eq('Time Other')
        end
        
      end
      
    end

  end

  describe 'display_name' do

    it 'should use the display_name of the asset if it exists' do
      ftp_detail.display_name.should eq(ftp_detail.asset.display_name)
    end

    it 'should do No Asset Listed with the id if there is no asset attached to the ftp_detail' do
      ftp_detail.asset = nil
      ftp_detail.display_name.should eq("No Asset Listed #{ftp_detail.id}")
    end

  end

  describe 'import' do

    it 'should not call anything if the pause property is true' do
      expect(Net::FTP).not_to receive(:open)
      ftp_detail.pause = true
      ftp_detail.import
    end

    it 'should call Net::FTP.open' do
      expect(Net::FTP).to receive(:open).once
      ftp_detail.import
    end

    it 'should create an FtpImportLog if the import fails' do
      expect(Net::FTP).not_to receive(:open).and_raise(Exception)
      ftp_detail.import
      FtpImportLog.last.ftp_detail.should eq(ftp_detail)
    end


  end

  describe 'import_file' do

    it 'should raise an error if the file is blank' do
      expect {
        ftp_detail.send(:import_file, {}, nil)
      }.to raise_error
    end

  end

  describe 'header_monitor_points' do
    ftp_column_monitor_point = nil, ftp_column_monitor_point_b = nil, ftp_column_monitor_point_c = nil

    before(:each) do
      ftp_detail.date_column_name = 'Date'
      ftp_detail.time_column_name = 'Time'
      ftp_detail.save

      ftp_column_monitor_point = FactoryGirl.create(:ftp_column_monitor_point, :ftp_detail => ftp_detail)
      ftp_column_monitor_point_b = FactoryGirl.create(:ftp_column_monitor_point, :ftp_detail => ftp_detail)
      ftp_column_monitor_point_c = FactoryGirl.create(:ftp_column_monitor_point, :ftp_detail => ftp_detail)
    end

    it 'should return an empty object if there is no header passed in' do
      ftp_detail.send(:header_monitor_points, nil).should eq([])
    end

    it 'should return an empty object if the header is empty' do
      ftp_detail.send(:header_monitor_points, []).should eq([])
    end

    it 'should return an array of length 3 with the names of the monitor points in place of the header columns, nils in the place of others' do
      ftp_detail.send(:header_monitor_points, [ftp_column_monitor_point.column_name, 'Not a Name', ftp_column_monitor_point_c.column_name]).
          should eq([ftp_column_monitor_point.monitor_point.name, nil, ftp_column_monitor_point_c.monitor_point.name])
    end

    it 'should be able to return a header of all nils' do
      ftp_detail.send(:header_monitor_points, ['Some Column', 'Not a Name', 'Another not Column']).
          should eq([nil, nil, nil])
    end

    it 'should be able to return a header of all monitor points' do
      ftp_detail.send(:header_monitor_points, [ftp_column_monitor_point.column_name, ftp_column_monitor_point_c.column_name, ftp_column_monitor_point_b.column_name]).
          should eq([ftp_column_monitor_point.monitor_point.name, ftp_column_monitor_point_c.monitor_point.name, ftp_column_monitor_point_b.monitor_point.name])
    end

    it 'should leave the item that matches the date_column_name in place' do
      ftp_detail.send(:header_monitor_points, ['Some Column', 'Date', 'Another not Column']).
          should eq([nil, 'Date', nil])
    end

    it 'should leave the item that matches the time_column_name in place' do
      ftp_detail.send(:header_monitor_points, [ftp_column_monitor_point.column_name, ftp_column_monitor_point_c.column_name, 'Time']).
          should eq([ftp_column_monitor_point.monitor_point.name, ftp_column_monitor_point_c.monitor_point.name, 'Time'])
    end
  end

  describe 'create_or_change_date' do

    it 'should create a new date when passed nil and a valid string' do
      ftp_detail.send(:create_or_change_date, nil, '26-03-14').should eq(DateTime.new(2014, 03, 26))
    end

    it 'should play nice with slash dates' do
      ftp_detail.send(:create_or_change_date, nil, '15/02/14').should eq(DateTime.new(2014, 02, 15))
    end
    
    it 'should play nice with date pieces that are missing 0s' do
      ftp_detail.send(:create_or_change_date, nil, '1-2-14').should eq(DateTime.new(2014, 2, 1))
    end

    it 'should change the existing date to the use the pieces from the new one' do
      ftp_detail.send(:create_or_change_date, DateTime.new(2010, 10, 10, 5, 15), '1-2-14').should eq(DateTime.new(2014, 2, 1, 5, 15))
    end

  end

  describe 'create_or_change_time' do

    it 'should create a new date when passed nil and a valid string' do
      date_time = ftp_detail.send(:create_or_change_time, nil, '13:15:28')
      date_time.hour.should eq(13)
      date_time.min.should eq(15)
      date_time.sec.should eq(28)
    end

    it 'should play nice with time pieces that are missing 0s' do
      date_time = ftp_detail.send(:create_or_change_time, nil, '1:5:8')
      date_time.hour.should eq(1)
      date_time.min.should eq(5)
      date_time.sec.should eq(8)
    end

    it 'should change the existing date to the use the pieces from the new one' do
      ftp_detail.send(:create_or_change_time, DateTime.new(2011, 1, 13), '14:47:59').should eq(DateTime.new(2011, 1, 13, 14, 47, 59))
    end

  end

end
