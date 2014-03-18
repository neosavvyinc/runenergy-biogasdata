class DataCollision < ActiveRecord::Base

  has_many :readings

  def self.create_if_collision(reading)

  end

  def self.collisions(reading)

  end

  def display_name

  end

end
