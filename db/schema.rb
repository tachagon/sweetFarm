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

ActiveRecord::Schema.define(version: 20160324085420) do

  create_table "amphur", primary_key: "AMPHUR_ID", force: :cascade do |t|
    t.string  "AMPHUR_CODE", limit: 4,               null: false
    t.string  "AMPHUR_NAME", limit: 150,             null: false
    t.integer "GEO_ID",      limit: 4,   default: 0, null: false
    t.integer "PROVINCE_ID", limit: 4,   default: 0, null: false
  end

  create_table "district", primary_key: "DISTRICT_ID", force: :cascade do |t|
    t.string  "DISTRICT_CODE", limit: 6,               null: false
    t.string  "DISTRICT_NAME", limit: 150,             null: false
    t.integer "AMPHUR_ID",     limit: 4,   default: 0, null: false
    t.integer "PROVINCE_ID",   limit: 4,   default: 0, null: false
    t.integer "GEO_ID",        limit: 4,   default: 0, null: false
  end

  create_table "geography", primary_key: "GEO_ID", force: :cascade do |t|
    t.string "GEO_NAME", limit: 255, null: false
  end

  create_table "province", primary_key: "PROVINCE_ID", force: :cascade do |t|
    t.string  "PROVINCE_CODE", limit: 2,               null: false
    t.string  "PROVINCE_NAME", limit: 150,             null: false
    t.integer "GEO_ID",        limit: 4,   default: 0, null: false
  end

  create_table "sale_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sales", force: :cascade do |t|
    t.float    "amount",         limit: 24
    t.float    "price",          limit: 24
    t.integer  "district_id",    limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "expire"
    t.integer  "sale_status_id", limit: 4
    t.boolean  "show",                      default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "sales", ["district_id"], name: "index_sales_on_district_id", using: :btree
  add_index "sales", ["sale_status_id"], name: "index_sales_on_sale_status_id", using: :btree
  add_index "sales", ["user_id"], name: "index_sales_on_user_id", using: :btree

  create_table "single_sign_ons", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "single_sign_ons", ["user_id"], name: "index_single_sign_ons_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
    t.boolean  "admin",                       default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "role",            limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "zipcode", primary_key: "ZIPCODE_ID", force: :cascade do |t|
    t.string "DISTRICT_CODE", limit: 100, null: false
    t.string "PROVINCE_ID",   limit: 100, null: false
    t.string "AMPHUR_ID",     limit: 100, null: false
    t.string "DISTRICT_ID",   limit: 100, null: false
    t.string "ZIPCODE",       limit: 5,   null: false
  end

  add_foreign_key "sales", "sale_statuses"
  add_foreign_key "sales", "users"
  add_foreign_key "single_sign_ons", "users"
end
