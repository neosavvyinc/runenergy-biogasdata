class AddPauseToFlareSpecfication < ActiveRecord::Migration
  def change
    add_column :flare_specifications, :pause, :boolean
  end
end
