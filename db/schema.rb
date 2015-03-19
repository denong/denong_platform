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

ActiveRecord::Schema.define(version: 20150319075020) do

  create_table "merchant_busi_reg_infos", force: true do |t|
    t.string   "name"
    t.string   "addr"
    t.string   "legal"
    t.string   "id_card"
    t.string   "licence"
    t.string   "organize_code"
    t.string   "tax_code"
    t.integer  "merchant_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merchant_busi_reg_infos", ["merchant_user_id"], name: "index_merchant_busi_reg_infos_on_merchant_user_id"

  create_table "merchant_sys_reg_infos", force: true do |t|
    t.string   "sys_name"
    t.string   "contact_person"
    t.string   "contact_tel",      default: "--- []\n"
    t.string   "service_tel",      default: "--- []\n"
    t.string   "fax_tel",          default: "--- []\n"
    t.string   "email"
    t.string   "company_addr"
    t.string   "region"
    t.string   "industry"
    t.string   "postcode"
    t.datetime "reg_time"
    t.datetime "approve_time"
    t.float    "lon"
    t.float    "lat"
    t.string   "welcome_string"
    t.text     "comment_text"
    t.integer  "merchant_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merchant_sys_reg_infos", ["merchant_user_id"], name: "index_merchant_sys_reg_infos_on_merchant_user_id"

  create_table "merchant_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "phone",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "authentication_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merchant_users", ["authentication_token"], name: "index_merchant_users_on_authentication_token", unique: true
  add_index "merchant_users", ["email"], name: "index_merchant_users_on_email"
  add_index "merchant_users", ["phone"], name: "index_merchant_users_on_phone"
  add_index "merchant_users", ["reset_password_token"], name: "index_merchant_users_on_reset_password_token", unique: true

  create_table "merchants", force: true do |t|
    t.integer  "merchant_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pos_machines", force: true do |t|
    t.integer  "acquiring_bank"
    t.string   "operator"
    t.datetime "opertion_time"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pos_machines", ["shop_id"], name: "index_pos_machines_on_shop_id"

  create_table "shops", force: true do |t|
    t.string   "name"
    t.string   "addr"
    t.string   "contact_person"
    t.string   "contact_tel"
    t.string   "work_time"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["merchant_id"], name: "index_shops_on_merchant_id"

  create_table "tl_trades", force: true do |t|
    t.string   "phone"
    t.string   "card"
    t.float    "price"
    t.datetime "trade_time"
    t.string   "pos_ind"
    t.string   "shop_ind"
    t.string   "trade_ind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tl_trades", ["phone"], name: "index_tl_trades_on_phone"
  add_index "tl_trades", ["pos_ind"], name: "index_tl_trades_on_pos_ind"
  add_index "tl_trades", ["shop_ind"], name: "index_tl_trades_on_shop_ind"
  add_index "tl_trades", ["trade_ind"], name: "index_tl_trades_on_trade_ind"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
