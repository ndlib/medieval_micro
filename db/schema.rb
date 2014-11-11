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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130402161936) do

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id",     null: false
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.string   "name_variants"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifications", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classifications", ["name"], name: "index_classifications_on_name", using: :btree

  create_table "classifications_facsimiles", id: false, force: true do |t|
    t.integer "facsimile_id",      null: false
    t.integer "classification_id", null: false
  end

  add_index "classifications_facsimiles", ["classification_id"], name: "index_classifications_facsimiles_on_classification_id", using: :btree
  add_index "classifications_facsimiles", ["facsimile_id", "classification_id"], name: "index_classifications_facsimiles_on_both_ids", using: :btree
  add_index "classifications_facsimiles", ["facsimile_id"], name: "index_classifications_facsimiles_on_facsimile_id", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", using: :btree

  create_table "date_ranges", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "date_ranges_facsimiles", id: false, force: true do |t|
    t.integer "facsimile_id",  null: false
    t.integer "date_range_id", null: false
  end

  add_index "date_ranges_facsimiles", ["date_range_id"], name: "index_date_ranges_facsimiles_on_date_range_id", using: :btree
  add_index "date_ranges_facsimiles", ["facsimile_id", "date_range_id"], name: "index_date_ranges_facsimiles_on_facsimile_id_and_date_range_id", using: :btree
  add_index "date_ranges_facsimiles", ["facsimile_id"], name: "index_date_ranges_facsimiles_on_facsimile_id", using: :btree

  create_table "default_attribute_types", force: true do |t|
    t.string   "model_name"
    t.string   "attribute_name"
    t.boolean  "is_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_attribute_values", force: true do |t|
    t.integer  "user_id"
    t.integer  "default_attribute_type_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_attribute_values", ["default_attribute_type_id"], name: "index_default_attribute_values_on_default_attribute_type_id", using: :btree
  add_index "default_attribute_values", ["user_id"], name: "index_default_attribute_values_on_user_id", using: :btree

  create_table "facsimiles", force: true do |t|
    t.string   "title"
    t.string   "alternate_names"
    t.string   "shelf_mark"
    t.string   "origin"
    t.string   "dimensions"
    t.string   "century_keywords"
    t.string   "date_description"
    t.string   "author"
    t.text     "content"
    t.text     "hand"
    t.boolean  "illuminations"
    t.text     "type_of_decoration"
    t.boolean  "musical_notation"
    t.text     "type_of_musical_notation"
    t.string   "call_number"
    t.boolean  "commentary_volume"
    t.text     "nature_of_facsimile"
    t.string   "series"
    t.string   "publication_date"
    t.string   "place_of_publication"
    t.string   "publisher"
    t.string   "printer"
    t.text     "notes"
    t.text     "bibliography"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
  end

  add_index "facsimiles", ["country_id"], name: "index_facsimiles_on_country_id", using: :btree

  create_table "facsimiles_languages", id: false, force: true do |t|
    t.integer "facsimile_id", null: false
    t.integer "language_id",  null: false
  end

  add_index "facsimiles_languages", ["facsimile_id", "language_id"], name: "index_facsimiles_languages_on_facsimile_id_and_language_id", using: :btree
  add_index "facsimiles_languages", ["facsimile_id"], name: "index_facsimiles_languages_on_facsimile_id", using: :btree
  add_index "facsimiles_languages", ["language_id"], name: "index_facsimiles_languages_on_language_id", using: :btree

  create_table "facsimiles_libraries", id: false, force: true do |t|
    t.integer "facsimile_id", null: false
    t.integer "library_id",   null: false
  end

  add_index "facsimiles_libraries", ["facsimile_id", "library_id"], name: "index_facsimiles_libraries_on_facsimile_id_and_library_id", using: :btree
  add_index "facsimiles_libraries", ["facsimile_id"], name: "index_facsimiles_libraries_on_facsimile_id", using: :btree
  add_index "facsimiles_libraries", ["library_id"], name: "index_facsimiles_libraries_on_library_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "libraries", force: true do |t|
    t.string   "name"
    t.string   "name_variants"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microfilms", force: true do |t|
    t.string   "shelf_mark"
    t.string   "mss_name"
    t.text     "mss_note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id"
    t.integer  "location_id"
    t.integer  "collection_id"
    t.string   "reel"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", using: :btree
  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "searches", force: true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
