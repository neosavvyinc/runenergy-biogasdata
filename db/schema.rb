# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140626033223) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "asset_properties", :force => true do |t|
    t.integer  "monitor_class_id"
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "asset_property_values", :force => true do |t|
    t.string   "value"
    t.integer  "asset_property_id"
    t.integer  "asset_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.integer  "section_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "monitor_class_id"
    t.string   "unique_identifier"
    t.integer  "location_id"
  end

  create_table "assets_monitor_points", :id => false, :force => true do |t|
    t.integer  "asset_id"
    t.integer  "monitor_point_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "attribute_name_mappings", :force => true do |t|
    t.string   "attribute_name"
    t.string   "display_name"
    t.string   "applies_to_class"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "units"
    t.integer  "significant_digits"
    t.integer  "column_weight"
  end

  create_table "column_conversion_mappings", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "ignored_column_or_conversion_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "csv_mapping_pairs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "custom_monitor_calculations", :force => true do |t|
    t.string   "value"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "locations_monitor_class_id"
    t.string   "name"
    t.integer  "significant_digits"
  end

  create_table "data_collisions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "device_profiles", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "device_profiles_user_groups", :id => false, :force => true do |t|
    t.integer  "device_profile_id"
    t.integer  "user_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "device_profiles_users", :id => false, :force => true do |t|
    t.integer  "device_profile_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "exception_notifications", :force => true do |t|
    t.integer  "locations_monitor_class_id"
    t.integer  "user_id"
    t.string   "other_email"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "field_log_points", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "field_log_points_locations_monitor_classes", :id => false, :force => true do |t|
    t.integer  "field_log_point_id"
    t.integer  "locations_monitor_class_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "field_logs", :force => true do |t|
    t.datetime "taken_at"
    t.string   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "flare_collection_statistics", :force => true do |t|
    t.date     "last_reading_collected"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "last_csv_read"
  end

  create_table "flare_data_mappings", :force => true do |t|
    t.string   "inlet_pressure_column"
    t.string   "blower_speed_column"
    t.string   "methane_column"
    t.string   "flame_temperature_column"
    t.string   "static_pressure_column"
    t.string   "lfg_temperature_column"
    t.string   "standard_methane_volume_column"
    t.string   "standard_lfg_flow_column"
    t.string   "standard_lfg_volume_column"
    t.string   "standard_cumulative_lfg_volume_column"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "name"
    t.string   "flame_trap_temperature_column"
    t.string   "flare_run_hours_column"
  end

  create_table "flare_deployment_status_codes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "flare_deployments", :force => true do |t|
    t.string   "flare_specification_id"
    t.integer  "location_id"
    t.integer  "customer_id"
    t.string   "client_flare_unique_identifier"
    t.integer  "flare_data_mapping_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.date     "first_reading"
    t.date     "last_reading"
    t.integer  "flare_deployment_status_code_id"
  end

  create_table "flare_import_logs", :force => true do |t|
    t.string   "message"
    t.integer  "flare_specification_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "likely_cause"
  end

  create_table "flare_monitor_data", :force => true do |t|
    t.datetime "date_time_reading"
    t.decimal  "inlet_pressure",                 :precision => 20, :scale => 10
    t.decimal  "blower_speed",                   :precision => 20, :scale => 10
    t.decimal  "methane",                        :precision => 20, :scale => 10
    t.decimal  "flame_temperature",              :precision => 20, :scale => 10
    t.decimal  "standard_lfg_flow",              :precision => 20, :scale => 10
    t.decimal  "standard_cumulative_lfg_volume", :precision => 20, :scale => 10
    t.decimal  "static_pressure",                :precision => 20, :scale => 10
    t.decimal  "lfg_temperature",                :precision => 20, :scale => 10
    t.decimal  "standard_lfg_volume",            :precision => 20, :scale => 10
    t.decimal  "standard_methane_volume",        :precision => 20, :scale => 10
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.integer  "flare_specification_id"
    t.decimal  "flame_trap_temperature",         :precision => 20, :scale => 10
    t.decimal  "flare_run_hours",                :precision => 20, :scale => 10
  end

  create_table "flare_specifications", :force => true do |t|
    t.string   "flare_unique_identifier"
    t.integer  "capacity_scmh"
    t.integer  "manufacturer_id"
    t.date     "purchase_date"
    t.string   "manufacturer_product_id"
    t.integer  "owner_id"
    t.string   "web_address"
    t.string   "ftp_address"
    t.string   "username"
    t.string   "password"
    t.string   "data_location"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "flare_collection_statistic_id"
    t.boolean  "pause"
    t.integer  "flare_data_mapping_id"
  end

  create_table "ftp_column_monitor_points", :force => true do |t|
    t.integer  "ftp_detail_id"
    t.integer  "monitor_point_id"
    t.string   "format"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "column_name"
  end

  create_table "ftp_details", :force => true do |t|
    t.integer  "asset_id"
    t.string   "username"
    t.string   "password"
    t.text     "url"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.date     "minimum_date"
    t.string   "folder_path"
    t.string   "date_column_name"
    t.boolean  "pause"
    t.date     "last_date_collected"
    t.string   "time_column_name"
  end

  create_table "ftp_import_logs", :force => true do |t|
    t.integer  "ftp_detail_id"
    t.text     "error"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "heat_map_details", :force => true do |t|
    t.string   "x"
    t.string   "y"
    t.integer  "symbol_id"
    t.integer  "asset_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ignored_column_or_conversions", :force => true do |t|
    t.boolean  "ignore"
    t.string   "convert_to"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ignored_columns_or_conversions_monitor_classes", :force => true do |t|
    t.integer  "monitor_class_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "ignored_column_or_conversion_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "site_name"
    t.text     "address"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "lattitude"
    t.string   "longitude"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "google_earth_file_file_name"
    t.string   "google_earth_file_content_type"
    t.integer  "google_earth_file_file_size"
    t.datetime "google_earth_file_updated_at"
    t.integer  "company_id"
  end

  create_table "locations_monitor_classes", :force => true do |t|
    t.integer "location_id"
    t.integer "monitor_class_id"
    t.string  "column_cache",         :limit => 8000
    t.string  "deleted_column_cache", :limit => 8000
    t.string  "asset_column_name"
    t.string  "date_column_name"
    t.string  "date_format"
  end

  create_table "locations_user_groups", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "locations_users", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "monitor_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.text     "monitor_point_ordering"
  end

  create_table "monitor_classes_field_log_points", :id => false, :force => true do |t|
    t.integer "monitor_class_id"
    t.integer "field_log_point_id"
  end

  create_table "monitor_classes_monitor_points", :id => false, :force => true do |t|
    t.integer "monitor_class_id"
    t.integer "monitor_point_id"
  end

  create_table "monitor_limits", :force => true do |t|
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "upper_limit"
    t.string   "lower_limit"
    t.integer  "monitor_point_id"
    t.integer  "locations_monitor_class_id"
  end

  create_table "monitor_points", :force => true do |t|
    t.string   "name"
    t.string   "unit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "monitor_points_locations_monitor_classes", :force => true do |t|
    t.integer  "monitor_point_id"
    t.integer  "locations_monitor_class_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "readings", :force => true do |t|
    t.datetime "taken_at"
    t.string   "data",              :limit => 8000
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "field_log_id"
    t.integer  "monitor_class_id"
    t.integer  "location_id"
    t.integer  "asset_id"
    t.integer  "data_collision_id"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "location_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "postal_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "country_id"
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "edit_permission"
  end

  create_table "user_groups_users", :id => false, :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "user_type_id"
    t.string   "name"
    t.string   "authentication_token"
    t.boolean  "edit_permission"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
