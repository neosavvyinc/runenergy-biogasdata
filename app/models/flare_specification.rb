class FlareSpecification < ActiveRecord::Base
  attr_accessible :capacity_scmh, :data_location, :flare_id, :ftp_address, :manufacturer_id, :manufacturer_product_id, :owner_id, :password, :purchase_date, :username, :web_address
  belongs_to :owner, :class_name => 'Company', :foreign_key => 'owner_id'
  belongs_to :manufacturer, :class_name => 'Company', :foreign_key => 'manufacturer_id'
  has_one :flare_deployment
end
