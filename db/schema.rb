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

ActiveRecord::Schema.define(version: 20150530081902) do

  create_table "admins", force: true do |t|
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
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "bank_card_infos", force: true do |t|
    t.string   "bin"
    t.string   "bank"
    t.string   "card_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bank_card_infos", ["bin"], name: "index_bank_card_infos_on_bin"

  create_table "bank_cards", force: true do |t|
    t.string   "bankcard_no"
    t.string   "id_card"
    t.string   "name"
    t.string   "phone"
    t.integer  "card_type"
    t.string   "sn"
    t.integer  "bank"
    t.integer  "bind_state"
    t.datetime "bind_time"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "res_msg"
    t.string   "stat_desc"
  end

  add_index "bank_cards", ["customer_id"], name: "index_bank_cards_on_customer_id"

  create_table "customer_reg_infos", force: true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verify_state"
    t.string   "id_card"
    t.string   "nick_name"
    t.integer  "gender"
  end

  add_index "customer_reg_infos", ["customer_id"], name: "index_customer_reg_infos_on_customer_id"

  create_table "customers", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id"

  create_table "exchange_logs", force: true do |t|
    t.integer  "customer_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exchange_logs", ["customer_id"], name: "index_exchange_logs_on_customer_id"

  create_table "friendships", force: true do |t|
    t.integer  "friend_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["customer_id"], name: "index_friendships_on_customer_id"

  create_table "gain_accounts", force: true do |t|
    t.integer  "customer_id"
    t.integer  "gain_org_id"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gain_accounts", ["customer_id"], name: "index_gain_accounts_on_customer_id"
  add_index "gain_accounts", ["gain_org_id"], name: "index_gain_accounts_on_gain_org_id"

  create_table "gain_histories", force: true do |t|
    t.float    "gain"
    t.datetime "gain_date"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gain_account_id"
  end

  add_index "gain_histories", ["customer_id"], name: "index_gain_histories_on_customer_id"
  add_index "gain_histories", ["gain_account_id"], name: "index_gain_histories_on_gain_account_id"

  create_table "gain_orgs", force: true do |t|
    t.string   "title"
    t.string   "sub_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "given_logs", force: true do |t|
    t.integer  "giver_or_given_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  add_index "given_logs", ["customer_id"], name: "index_given_logs_on_customer_id"
  add_index "given_logs", ["giver_or_given_id"], name: "index_given_logs_on_giver_or_given_id"

  create_table "identity_verifies", force: true do |t|
    t.string   "name"
    t.integer  "verify_state"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_card"
  end

  add_index "identity_verifies", ["customer_id"], name: "index_identity_verifies_on_customer_id"

  create_table "images", force: true do |t|
    t.string   "title"
    t.string   "photo_type"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"

  create_table "jajin_identity_codes", force: true do |t|
    t.datetime "expiration_time"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "amount"
    t.string   "verify_code"
    t.integer  "verify_state",    default: 0
    t.string   "trade_time"
    t.string   "company"
  end

  add_index "jajin_identity_codes", ["company"], name: "index_jajin_identity_codes_on_company"
  add_index "jajin_identity_codes", ["merchant_id"], name: "index_jajin_identity_codes_on_merchant_id"
  add_index "jajin_identity_codes", ["verify_code"], name: "index_jajin_identity_codes_on_verify_code"

  create_table "jajin_logs", force: true do |t|
    t.float    "amount"
    t.integer  "jajinable_id"
    t.string   "jajinable_type"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jajin_logs", ["customer_id"], name: "index_jajin_logs_on_customer_id"
  add_index "jajin_logs", ["jajinable_id", "jajinable_type"], name: "index_jajin_logs_on_jajinable_id_and_jajinable_type"

  create_table "jajin_verify_logs", force: true do |t|
    t.float    "amount"
    t.string   "verify_code"
    t.datetime "verify_time"
    t.integer  "customer_id"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company"
  end

  add_index "jajin_verify_logs", ["customer_id"], name: "index_jajin_verify_logs_on_customer_id"
  add_index "jajin_verify_logs", ["merchant_id"], name: "index_jajin_verify_logs_on_merchant_id"

  create_table "jajins", force: true do |t|
    t.float    "got"
    t.float    "unverify"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jajins", ["customer_id"], name: "index_jajins_on_customer_id"

  create_table "member_cards", force: true do |t|
    t.integer  "merchant_id"
    t.float    "point"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
    t.string   "passwd"
  end

  add_index "member_cards", ["customer_id"], name: "index_member_cards_on_customer_id"
  add_index "member_cards", ["merchant_id"], name: "index_member_cards_on_merchant_id"

  create_table "merchant_busi_reg_infos", force: true do |t|
    t.string   "name"
    t.string   "addr"
    t.string   "legal"
    t.string   "id_card"
    t.string   "licence"
    t.string   "organize_code"
    t.string   "tax_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  add_index "merchant_busi_reg_infos", ["merchant_id"], name: "index_merchant_busi_reg_infos_on_merchant_id"

  create_table "merchant_giving_logs", force: true do |t|
    t.float    "amount"
    t.datetime "giving_time"
    t.integer  "merchant_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
    t.float    "consumption"
  end

  add_index "merchant_giving_logs", ["customer_id"], name: "index_merchant_giving_logs_on_customer_id"
  add_index "merchant_giving_logs", ["merchant_id"], name: "index_merchant_giving_logs_on_merchant_id"
  add_index "merchant_giving_logs", ["shop_id"], name: "index_merchant_giving_logs_on_shop_id"

  create_table "merchant_messages", force: true do |t|
    t.datetime "time"
    t.string   "title"
    t.string   "content"
    t.string   "summary"
    t.string   "url"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "verify_state"
  end

  add_index "merchant_messages", ["customer_id"], name: "index_merchant_messages_on_customer_id"
  add_index "merchant_messages", ["merchant_id"], name: "index_merchant_messages_on_merchant_id"

  create_table "merchant_sys_reg_infos", force: true do |t|
    t.string   "sys_name"
    t.string   "contact_person"
    t.string   "contact_tel",    default: "--- []\n"
    t.string   "service_tel",    default: "--- []\n"
    t.string   "fax_tel",        default: "--- []\n"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  add_index "merchant_sys_reg_infos", ["merchant_id"], name: "index_merchant_sys_reg_infos_on_merchant_id"

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
    t.float    "ratio"
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
    t.integer  "topic_id"
    t.float    "consumption_total"
    t.float    "jajin_total"
    t.integer  "consume_count"
  end

  add_index "merchants", ["cached_votes_down"], name: "index_merchants_on_cached_votes_down"
  add_index "merchants", ["cached_votes_score"], name: "index_merchants_on_cached_votes_score"
  add_index "merchants", ["cached_votes_total"], name: "index_merchants_on_cached_votes_total"
  add_index "merchants", ["cached_votes_up"], name: "index_merchants_on_cached_votes_up"
  add_index "merchants", ["cached_weighted_average"], name: "index_merchants_on_cached_weighted_average"
  add_index "merchants", ["cached_weighted_score"], name: "index_merchants_on_cached_weighted_score"
  add_index "merchants", ["cached_weighted_total"], name: "index_merchants_on_cached_weighted_total"
  add_index "merchants", ["topic_id"], name: "index_merchants_on_topic_id"

  create_table "pensions", force: true do |t|
    t.float    "total"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account"
  end

  add_index "pensions", ["customer_id"], name: "index_pensions_on_customer_id"

  create_table "pos_machines", force: true do |t|
    t.integer  "acquiring_bank"
    t.string   "operator"
    t.datetime "opertion_time"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pos_ind"
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
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
    t.float    "lon"
    t.float    "lat"
    t.string   "post_code"
    t.string   "email"
    t.string   "service_tel"
    t.string   "welcome_text"
    t.string   "remark"
  end

  add_index "shops", ["cached_votes_down"], name: "index_shops_on_cached_votes_down"
  add_index "shops", ["cached_votes_score"], name: "index_shops_on_cached_votes_score"
  add_index "shops", ["cached_votes_total"], name: "index_shops_on_cached_votes_total"
  add_index "shops", ["cached_votes_up"], name: "index_shops_on_cached_votes_up"
  add_index "shops", ["cached_weighted_average"], name: "index_shops_on_cached_weighted_average"
  add_index "shops", ["cached_weighted_score"], name: "index_shops_on_cached_weighted_score"
  add_index "shops", ["cached_weighted_total"], name: "index_shops_on_cached_weighted_total"
  add_index "shops", ["merchant_id"], name: "index_shops_on_merchant_id"

  create_table "sms_tokens", force: true do |t|
    t.string   "phone"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sms_tokens", ["phone"], name: "index_sms_tokens_on_phone"

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "tickets", force: true do |t|
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tl_trades", force: true do |t|
    t.string   "phone"
    t.string   "card"
    t.float    "price"
    t.string   "pos_ind"
    t.string   "shop_ind"
    t.string   "trade_ind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "merchant_id"
    t.string   "trade_time"
    t.integer  "pos_machine_id"
  end

  add_index "tl_trades", ["customer_id"], name: "index_tl_trades_on_customer_id"
  add_index "tl_trades", ["merchant_id"], name: "index_tl_trades_on_merchant_id"
  add_index "tl_trades", ["phone"], name: "index_tl_trades_on_phone"
  add_index "tl_trades", ["pos_ind"], name: "index_tl_trades_on_pos_ind"
  add_index "tl_trades", ["pos_machine_id"], name: "index_tl_trades_on_pos_machine_id"
  add_index "tl_trades", ["shop_ind"], name: "index_tl_trades_on_shop_ind"
  add_index "tl_trades", ["trade_ind"], name: "index_tl_trades_on_trade_ind"

  create_table "topics", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tags",                    default: "--- []\n"
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
  end

  add_index "topics", ["cached_votes_down"], name: "index_topics_on_cached_votes_down"
  add_index "topics", ["cached_votes_score"], name: "index_topics_on_cached_votes_score"
  add_index "topics", ["cached_votes_total"], name: "index_topics_on_cached_votes_total"
  add_index "topics", ["cached_votes_up"], name: "index_topics_on_cached_votes_up"
  add_index "topics", ["cached_weighted_average"], name: "index_topics_on_cached_weighted_average"
  add_index "topics", ["cached_weighted_score"], name: "index_topics_on_cached_weighted_score"
  add_index "topics", ["cached_weighted_total"], name: "index_topics_on_cached_weighted_total"

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

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

  create_table "yl_trades", force: true do |t|
    t.datetime "trade_time"
    t.date     "log_time"
    t.string   "trade_currency"
    t.string   "trade_state"
    t.float    "gain"
    t.float    "expend"
    t.string   "merchant_ind"
    t.string   "pos_ind"
    t.string   "merchant_name"
    t.string   "merchant_type"
    t.string   "merchant_city"
    t.string   "trade_type"
    t.string   "trade_way"
    t.string   "merchant_addr"
    t.integer  "customer_id"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card"
  end

  add_index "yl_trades", ["customer_id"], name: "index_yl_trades_on_customer_id"
  add_index "yl_trades", ["merchant_id"], name: "index_yl_trades_on_merchant_id"

end
