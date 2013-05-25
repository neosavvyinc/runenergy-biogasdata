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

ActiveRecord::Schema.define(:version => 20130525205336) do

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

  create_table "flare_monitor_data", :force => true do |t|
    t.datetime "date_time_reading"
    t.decimal  "inlet_pressure",                 :precision => 10, :scale => 0
    t.decimal  "blower_speed",                   :precision => 10, :scale => 0
    t.decimal  "methane",                        :precision => 10, :scale => 0
    t.decimal  "flame_temperature",              :precision => 10, :scale => 0
    t.decimal  "standard_lfg_flow",              :precision => 10, :scale => 0
    t.decimal  "standard_cumulative_lfg_volume", :precision => 10, :scale => 0
    t.decimal  "static_pressure",                :precision => 10, :scale => 0
    t.decimal  "lfg_temperature",                :precision => 10, :scale => 0
    t.decimal  "standard_lfg_volume",            :precision => 10, :scale => 0
    t.decimal  "standard_methane_volume",        :precision => 10, :scale => 0
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  create_table "flare_specifications", :force => true do |t|
    t.string   "flare_id"
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
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

end
