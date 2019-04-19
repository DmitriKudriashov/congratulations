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

ActiveRecord::Schema.define(version: 2019_04_19_084653) do

  create_table "companies", force: :cascade do |t|
    t.string "name", default: ""
    t.integer "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "companies_people", force: :cascade do |t|
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_companies_people_on_person_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", default: ""
    t.string "code", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "countries_holidays", force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "holiday_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_countries_holidays_on_country_id"
    t.index ["holiday_id"], name: "index_countries_holidays_on_holiday_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name", default: ""
    t.integer "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_holidays_on_country_id"
    t.index ["name"], name: "index_holidays_on_name", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name", default: ""
    t.string "email", default: ""
    t.integer "country_id", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_people_on_company_id"
    t.index ["country_id"], name: "index_people_on_country_id"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["name"], name: "index_people_on_name", unique: true
  end

end
