class AddGoogleEarthFileToLocation < ActiveRecord::Migration
  def change
    add_attachment :locations, :google_earth_file
  end
end
