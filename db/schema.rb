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

ActiveRecord::Schema.define(version: 2019_05_07_102216) do

  create_table "cardtexts", force: :cascade do |t|
    t.string "filename", default: ""
    t.text "text", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_cardtexts_on_filename", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", default: ""
    t.integer "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "companies_holidays", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "holiday_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "holiday_id"], name: "index_companies_holidays_on_company_id_and_holiday_id", unique: true
    t.index ["company_id"], name: "index_companies_holidays_on_company_id"
    t.index ["holiday_id"], name: "index_companies_holidays_on_holiday_id"
  end

  create_table "companies_people", force: :cascade do |t|
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.index ["company_id", "person_id"], name: "index_companies_people_on_company_id_and_person_id", unique: true
    t.index ["company_id"], name: "index_companies_people_on_company_id"
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
    t.index ["country_id", "holiday_id"], name: "index_countries_holidays_on_country_id_and_holiday_id", unique: true
    t.index ["country_id"], name: "index_countries_holidays_on_country_id"
    t.index ["holiday_id"], name: "index_countries_holidays_on_holiday_id"
  end

  create_table "dates_holidays", force: :cascade do |t|
    t.integer "day", default: 1, null: false
    t.integer "month", default: 1, null: false
    t.integer "year", default: 0, null: false
    t.integer "holiday_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["holiday_id", "day", "month", "year"], name: "index_dates_holidays_on_holiday_id_and_day_and_month_and_year", unique: true
    t.index ["holiday_id"], name: "index_dates_holidays_on_holiday_id"
  end

  create_table "email_cards", force: :cascade do |t|
    t.integer "email_id", null: false
    t.integer "postcard_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id", "postcard_id"], name: "index_email_cards_on_email_id_and_postcard_id", unique: true
    t.index ["email_id"], name: "index_email_cards_on_email_id"
    t.index ["postcard_id"], name: "index_email_cards_on_postcard_id"
  end

  create_table "email_texts", force: :cascade do |t|
    t.integer "email_id", null: false
    t.integer "cardtext_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cardtext_id"], name: "index_email_texts_on_cardtext_id"
    t.index ["email_id", "cardtext_id"], name: "index_email_texts_on_email_id_and_cardtext_id", unique: true
    t.index ["email_id"], name: "index_email_texts_on_email_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "name", default: ""
    t.string "address", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mail_address_id"
    t.index ["address"], name: "index_emails_on_address"
    t.index ["mail_address_id"], name: "index_emails_on_mail_address_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_id"
    t.index ["name"], name: "index_holidays_on_name", unique: true
    t.index ["type_id"], name: "index_holidays_on_type_id"
  end

  create_table "mail_addresses", force: :cascade do |t|
    t.string "email", default: ""
    t.integer "companies_person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["companies_person_id"], name: "index_mail_addresses_on_companies_person_id"
    t.index ["email"], name: "index_mail_addresses_on_email"
  end

  create_table "people", force: :cascade do |t|
    t.string "name", default: ""
    t.string "email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["name"], name: "index_people_on_name", unique: true
  end

  create_table "postcards", force: :cascade do |t|
    t.string "filename", default: ""
    t.binary "image", limit: 16777216
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_types_on_name"
  end

end
