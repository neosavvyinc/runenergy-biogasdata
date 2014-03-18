class DataCollision < ActiveRecord::Base

  has_many :readings

  def self.create_if_collision(reading)
    collisions = self.collisions(reading)
    if collisions.size > 0
      collisions << reading
      dc = self.check_for_existing(collisions, reading.reload)
      if dc.nil?
        dc = DataCollision.create
        dc.readings << collisions
      end
      dc
    else
      nil
    end
  end

  def self.collisions(reading)
    Reading.where('asset_id = ? and taken_at = ? and id != ?', reading.asset_id, reading.taken_at, reading.id)
  end

  def self.check_for_existing(collisions, reading)
    unless reading.data_collision_id.nil?
      dc = DataCollision.where(:id => reading.data_collision_id).first
      unless dc.nil? or collisions.map {|c| c.id}.sort != dc.readings.map {|r| r.id}.sort
        dc
      else
        nil
      end
    else
      nil
    end
  end

  def display_name
    if readings and readings.size > 0
      "Data Collision: #{readings.first.asset.try(:unique_identifier)}, #{readings.first.taken_at.try(:strftime, '%b %e, %l:%M %p')}"
    else
      'No Readings'
    end
  end

end
