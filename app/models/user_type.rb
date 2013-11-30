class UserType < ActiveRecord::Base
  attr_accessible :name

  def self.OVERSEER
    UserType.find_by_name("OVERSEER")
  end

  def self.CUSTOMER
    UserType.find_by_name("CUSTOMER")
  end

  def self.WORKER
    UserType.find_by_name("WORKER")
  end
end
