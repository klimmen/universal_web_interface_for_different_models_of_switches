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

ActiveRecord::Schema.define(version: 20150227192342) do

  create_table "firmware_mibs", force: :cascade do |t|
    t.integer  "firmware_id", null: false
    t.integer  "mib_id",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "firmware_mibs", ["firmware_id"], name: "index_firmware_mibs_on_firmware_id"
  add_index "firmware_mibs", ["mib_id"], name: "index_firmware_mibs_on_mib_id"

  create_table "firmwares", force: :cascade do |t|
    t.string   "name",            null: false
    t.integer  "switch_model_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "firmwares", ["switch_model_id"], name: "index_firmwares_on_switch_model_id"

  create_table "mibs", force: :cascade do |t|
    t.string   "name",         null: false
    t.integer  "value_oid_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "mibs", ["value_oid_id"], name: "index_mibs_on_value_oid_id"

  create_table "switch_models", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "switches", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "ip",                           null: false
    t.string   "login",      default: "admin", null: false
    t.string   "pass",                         null: false
    t.string   "snmp",                         null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "switches", ["ip"], name: "index_switches_on_ip"
  add_index "switches", ["name"], name: "index_switches_on_name"

  create_table "value_oids", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
