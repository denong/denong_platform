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

ActiveRecord::Schema.define(version: 20150307105043) do

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

end
