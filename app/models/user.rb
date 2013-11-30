class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :user_type_id
  belongs_to :user_type
  has_many :user_groups_users
  has_many :user_groups, :through => :user_groups_users
  has_many :device_profiles_users
  has_many :device_profiles, :through => :device_profiles_users
  has_many :locations_user_groups
  has_many :locations, :through => :locations_user_groups
  # attr_accessible :title, :body

  def is_overseer?
    self.user_type == UserType.OVERSEER
  end

  def is_customer?
    self.user_type == UserType.CUSTOMER
  end

  def is_worker?
    self.user_type == UserType.WORKER
  end

  def sites
    locations.try(:as_json, :monitor_classes)
  end

end
