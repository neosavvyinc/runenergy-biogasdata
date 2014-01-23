class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :user_type_id, :location_ids, :authentication_token
  belongs_to :user_type
  has_many :user_groups_users
  has_many :user_groups, :through => :user_groups_users
  has_many :device_profiles_users
  has_many :device_profiles, :through => :device_profiles_users
  has_many :locations_users
  has_many :locations, :through => :locations_users
  # attr_accessible :title, :body

  def all_locations
    if is_overseer?
      Location.all
    else
      user_group_locations = (user_groups.map {|ug| ug.locations}).flatten
      if user_group_locations and user_group_locations.size
        locations + user_group_locations
      else
        locations
      end
    end
  end

  def is_overseer?
    self.user_type == UserType.OVERSEER
  end

  def is_customer?
    self.user_type == UserType.CUSTOMER
  end

  def is_worker?
    self.user_type == UserType.WORKER
  end

  def entitled_site_ids
    (locations + user_groups.collect {|ug| ug.locations}.flatten).collect {|l| l.id}
  end

end
