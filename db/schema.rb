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

ActiveRecord::Schema.define(version: 20171115203124) do

  create_table "available_unit_types", force: :cascade do |t|
    t.integer "facility_info_id"
    t.integer "i_type_id",                         null: false
    t.string  "cs_type_description", default: "",  null: false
    t.float   "d_price",             default: 0.0, null: false
    t.integer "availability",        default: 0,   null: false
    t.string  "cs_last_unit",        default: "",  null: false
    t.index ["facility_info_id"], name: "index_available_unit_types_on_facility_info_id"
    t.index ["i_type_id"], name: "index_available_unit_types_on_i_type_id"
  end

  create_table "available_units", force: :cascade do |t|
    t.integer "available_unit_type_id"
    t.string  "cs_unit_id",             default: "",  null: false
    t.float   "d_rent",                 default: 0.0, null: false
    t.index ["available_unit_type_id"], name: "index_available_units_on_available_unit_type_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string   "user"
    t.string   "password"
    t.string   "site"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facility_infos", force: :cascade do |t|
    t.integer "facility_id"
    t.boolean "success",                                  default: false, null: false
    t.string  "cs_site_name",                             default: "",    null: false
    t.string  "cs_site_address",                          default: "",    null: false
    t.string  "cs_site_city",                             default: "",    null: false
    t.string  "cs_site_state",                            default: "",    null: false
    t.string  "cs_site_zip",                              default: "",    null: false
    t.string  "cs_site_phone",                            default: "",    null: false
    t.string  "cs_site_email",                            default: "",    null: false
    t.string  "cs_smtp_name",                             default: "",    null: false
    t.string  "cs_smtp_user",                             default: "",    null: false
    t.string  "cs_smtp_password",                         default: "",    null: false
    t.string  "cs_smtp_need_auth",                        default: "",    null: false
    t.string  "cs_allow_payment_one_week_before_auction", default: "",    null: false
    t.string  "cs_allow_rent_unit",                       default: "",    null: false
    t.string  "cs_allow_reserve",                         default: "",    null: false
    t.string  "cs_allow_edit_tenant_info",                default: "",    null: false
    t.string  "cs_advertising",                           default: "",    null: false
    t.integer "i_advertising_days",                       default: 0,     null: false
    t.integer "cs_smtp_port",                             default: 25,    null: false
    t.boolean "cs_smtp_secure_log_on",                    default: false, null: false
    t.text    "st_processor_info",                        default: "{}",  null: false
    t.index ["facility_id"], name: "index_facility_infos_on_facility_id"
  end

end
