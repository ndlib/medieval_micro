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

ActiveRecord::Schema.define(version: 20200319125528) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,   null: false
    t.string   "document_id", limit: 255
    t.string   "title",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type",   limit: 255
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "name_variants", limit: 255
    t.string   "notes",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifications", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classifications", ["name"], name: "index_classifications_on_name", using: :btree

  create_table "classifications_facsimiles", id: false, force: :cascade do |t|
    t.integer "facsimile_id",      limit: 4, null: false
    t.integer "classification_id", limit: 4, null: false
  end

  add_index "classifications_facsimiles", ["classification_id"], name: "index_classifications_facsimiles_on_classification_id", using: :btree
  add_index "classifications_facsimiles", ["facsimile_id", "classification_id"], name: "index_classifications_facsimiles_on_both_ids", using: :btree
  add_index "classifications_facsimiles", ["facsimile_id"], name: "index_classifications_facsimiles_on_facsimile_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "notes",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", using: :btree

  create_table "date_ranges", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "date_ranges_facsimiles", id: false, force: :cascade do |t|
    t.integer "facsimile_id",  limit: 4, null: false
    t.integer "date_range_id", limit: 4, null: false
  end

  add_index "date_ranges_facsimiles", ["date_range_id"], name: "index_date_ranges_facsimiles_on_date_range_id", using: :btree
  add_index "date_ranges_facsimiles", ["facsimile_id", "date_range_id"], name: "index_date_ranges_facsimiles_on_facsimile_id_and_date_range_id", using: :btree
  add_index "date_ranges_facsimiles", ["facsimile_id"], name: "index_date_ranges_facsimiles_on_facsimile_id", using: :btree

  create_table "default_attribute_types", force: :cascade do |t|
    t.string   "model_class_name", limit: 255
    t.string   "attribute_name",   limit: 255
    t.boolean  "is_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_attribute_values", force: :cascade do |t|
    t.integer  "user_id",                   limit: 4
    t.integer  "default_attribute_type_id", limit: 4
    t.string   "value",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_attribute_values", ["default_attribute_type_id"], name: "index_default_attribute_values_on_default_attribute_type_id", using: :btree
  add_index "default_attribute_values", ["user_id"], name: "index_default_attribute_values_on_user_id", using: :btree

  create_table "facsimiles", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.string   "alternate_names",          limit: 255
    t.string   "shelf_mark",               limit: 255
    t.string   "origin",                   limit: 255
    t.string   "dimensions",               limit: 255
    t.string   "century_keywords",         limit: 255
    t.string   "date_description",         limit: 255
    t.string   "author",                   limit: 255
    t.text     "content",                  limit: 65535
    t.text     "hand",                     limit: 65535
    t.boolean  "illuminations"
    t.text     "type_of_decoration",       limit: 65535
    t.boolean  "musical_notation"
    t.text     "type_of_musical_notation", limit: 65535
    t.string   "call_number",              limit: 255
    t.boolean  "commentary_volume"
    t.text     "nature_of_facsimile",      limit: 65535
    t.string   "series",                   limit: 255
    t.string   "publication_date",         limit: 255
    t.string   "place_of_publication",     limit: 255
    t.string   "publisher",                limit: 255
    t.string   "printer",                  limit: 255
    t.text     "notes",                    limit: 65535
    t.text     "bibliography",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id",               limit: 4
  end

  add_index "facsimiles", ["country_id"], name: "index_facsimiles_on_country_id", using: :btree

  create_table "facsimiles_languages", id: false, force: :cascade do |t|
    t.integer "facsimile_id", limit: 4, null: false
    t.integer "language_id",  limit: 4, null: false
  end

  add_index "facsimiles_languages", ["facsimile_id", "language_id"], name: "index_facsimiles_languages_on_facsimile_id_and_language_id", using: :btree
  add_index "facsimiles_languages", ["facsimile_id"], name: "index_facsimiles_languages_on_facsimile_id", using: :btree
  add_index "facsimiles_languages", ["language_id"], name: "index_facsimiles_languages_on_language_id", using: :btree

  create_table "facsimiles_libraries", id: false, force: :cascade do |t|
    t.integer "facsimile_id", limit: 4, null: false
    t.integer "library_id",   limit: 4, null: false
  end

  add_index "facsimiles_libraries", ["facsimile_id", "library_id"], name: "index_facsimiles_libraries_on_facsimile_id_and_library_id", using: :btree
  add_index "facsimiles_libraries", ["facsimile_id"], name: "index_facsimiles_libraries_on_facsimile_id", using: :btree
  add_index "facsimiles_libraries", ["library_id"], name: "index_facsimiles_libraries_on_library_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "libraries", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "name_variants", limit: 255
    t.integer  "city_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "notes",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microfilms", force: :cascade do |t|
    t.string   "shelf_mark",    limit: 255
    t.string   "mss_name",      limit: 255
    t.text     "mss_note",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id",    limit: 4
    t.integer  "location_id",   limit: 4
    t.integer  "collection_id", limit: 4
    t.string   "reel",          limit: 255
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", using: :btree
  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.text     "query_params", limit: 65535
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type",    limit: 255
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "username",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",      limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
