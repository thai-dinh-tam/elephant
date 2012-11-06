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

ActiveRecord::Schema.define(:version => 20121106182800) do

  create_table "activities", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "activity_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "metadata"
    t.integer  "job_id"
  end

  add_index "activities", ["company_id"], :name => "index_activities_on_company_id"
  add_index "activities", ["job_id"], :name => "index_activities_on_job_id"
  add_index "activities", ["target_id", "target_type"], :name => "index_activities_on_target_id_and_target_type"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "clients", ["company_id"], :name => "index_clients_on_company_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "support_email"
    t.string   "phone_number"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "postal_code"
    t.string   "state"
    t.string   "country"
    t.integer  "admin_id"
    t.string   "logo"
    t.string   "logo_large"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "companies", ["name"], :name => "index_companies_on_name", :unique => true

  create_table "countries", :force => true do |t|
    t.string   "iso"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "location"
    t.integer  "country_id"
    t.integer  "state_id"
  end

  add_index "districts", ["company_id"], :name => "index_districts_on_company_id"
  add_index "districts", ["country_id"], :name => "index_districts_on_country_id"
  add_index "districts", ["state_id"], :name => "index_districts_on_state_id"

  create_table "documents", :force => true do |t|
    t.integer  "job_template_id"
    t.integer  "job_id"
    t.string   "category"
    t.string   "name"
    t.string   "url"
    t.string   "status"
    t.boolean  "template",             :default => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "document_type"
    t.integer  "company_id"
    t.integer  "document_template_id"
    t.integer  "user_id"
  end

  add_index "documents", ["company_id"], :name => "index_documents_on_company_id"
  add_index "documents", ["document_template_id"], :name => "index_documents_on_document_template_id"
  add_index "documents", ["job_id"], :name => "index_documents_on_job_id"
  add_index "documents", ["job_template_id"], :name => "index_documents_on_job_template_id"

  create_table "dynamic_fields", :force => true do |t|
    t.integer  "job_template_id"
    t.integer  "job_id"
    t.string   "name",                                          :null => false
    t.string   "value"
    t.string   "value_type_conversion",     :default => "to_s"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "template"
    t.integer  "company_id"
    t.boolean  "priority"
    t.integer  "dynamic_field_template_id"
  end

  add_index "dynamic_fields", ["company_id"], :name => "index_dynamic_fields_on_company_id"
  add_index "dynamic_fields", ["dynamic_field_template_id"], :name => "index_dynamic_fields_on_dynamic_field_template_id"
  add_index "dynamic_fields", ["job_id"], :name => "index_dynamic_fields_on_job_id"
  add_index "dynamic_fields", ["job_template_id"], :name => "index_dynamic_fields_on_job_template_id"
  add_index "dynamic_fields", ["name"], :name => "index_dynamic_fields_on_name"

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.integer  "district_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "location"
  end

  add_index "fields", ["company_id"], :name => "index_fields_on_company_id"
  add_index "fields", ["district_id"], :name => "index_fields_on_district_id"

  create_table "job_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "job_memberships", ["job_id"], :name => "index_job_memberships_on_job_id"
  add_index "job_memberships", ["user_id", "job_id"], :name => "index_job_memberships_on_user_id_and_job_id", :unique => true
  add_index "job_memberships", ["user_id"], :name => "index_job_memberships_on_user_id"

  create_table "job_templates", :force => true do |t|
    t.string   "name"
    t.integer  "product_line_id"
    t.integer  "company_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "job_templates", ["company_id"], :name => "index_job_templates_on_company_id"
  add_index "job_templates", ["product_line_id"], :name => "index_job_templates_on_product_line_id"

  create_table "jobs", :force => true do |t|
    t.integer  "job_template_id"
    t.integer  "field_id"
    t.integer  "well_id"
    t.integer  "district_id"
    t.integer  "client_id"
    t.string   "client_contact_name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "district_manager_id"
    t.integer  "sales_engineer_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "company_id"
  end

  add_index "jobs", ["client_id"], :name => "index_jobs_on_client_id"
  add_index "jobs", ["company_id"], :name => "index_jobs_on_company_id"
  add_index "jobs", ["district_id"], :name => "index_jobs_on_district_id"
  add_index "jobs", ["field_id"], :name => "index_jobs_on_field_id"
  add_index "jobs", ["job_template_id"], :name => "index_jobs_on_job_template_id"
  add_index "jobs", ["well_id"], :name => "index_jobs_on_well_id"

  create_table "product_lines", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_lines", ["company_id"], :name => "index_product_lines_on_company_id"

  create_table "states", :force => true do |t|
    t.string   "iso"
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "states", ["country_id"], :name => "index_states_on_country_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin",           :default => false
    t.boolean  "create_access",   :default => false
    t.boolean  "write_access",    :default => false
    t.integer  "company_id"
    t.integer  "district_id"
    t.string   "location"
    t.string   "position_title"
    t.string   "phone_number"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.boolean  "elephant_admin",  :default => false
    t.string   "remember_token"
    t.boolean  "create_password", :default => false
  end

  add_index "users", ["company_id"], :name => "index_users_on_company_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "wells", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.integer  "field_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.float    "measured_depth"
    t.float    "true_vertical_depth"
    t.float    "water_depth"
    t.boolean  "offshore",                       :default => false
    t.float    "bottom_hole_temperature"
    t.float    "bottom_hole_formation_pressure"
    t.float    "frac_pressure"
    t.string   "fuild_type"
    t.float    "fluid_weight"
    t.float    "max_deviation"
    t.float    "bottom_deviation"
    t.string   "rig_name"
  end

  add_index "wells", ["company_id"], :name => "index_wells_on_company_id"
  add_index "wells", ["field_id"], :name => "index_wells_on_field_id"

end
