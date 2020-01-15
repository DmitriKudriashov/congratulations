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

ActiveRecord::Schema.define(version: 2020_01_15_134934) do

  create_table "cardtexts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "filename"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "holiday_id"
    t.index ["filename"], name: "index_cardtexts_on_filename", unique: true
    t.index ["holiday_id"], name: "index_cardtexts_on_holiday_id"
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", default: ""
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: ""
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["email"], name: "index_companies_on_email"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "companies_emails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "email_id"
    t.bigint "company_id"
    t.string "comment", default: ""
    t.index ["company_id"], name: "index_companies_emails_on_company_id"
    t.index ["email_id"], name: "index_companies_emails_on_email_id"
  end

  create_table "companies_holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "holiday_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "holiday_id"], name: "index_companies_holidays_on_company_id_and_holiday_id", unique: true
    t.index ["company_id"], name: "index_companies_holidays_on_company_id"
    t.index ["holiday_id"], name: "index_companies_holidays_on_holiday_id"
  end

  create_table "companies_people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "person_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id", "person_id"], name: "index_companies_people_on_company_id_and_person_id", unique: true
    t.index ["company_id"], name: "index_companies_people_on_company_id"
    t.index ["person_id"], name: "index_companies_people_on_person_id"
  end

  create_table "countries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", default: ""
    t.string "code", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "countries_holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.bigint "holiday_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id", "holiday_id"], name: "index_countries_holidays_on_country_id_and_holiday_id", unique: true
    t.index ["country_id"], name: "index_countries_holidays_on_country_id"
    t.index ["holiday_id"], name: "index_countries_holidays_on_holiday_id"
  end

  create_table "dates_holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "day", default: 1, null: false
    t.integer "month", default: 1, null: false
    t.integer "year", default: 0, null: false
    t.bigint "holiday_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["holiday_id", "day", "month", "year"], name: "index_dates_holidays_on_holiday_id_and_day_and_month_and_year", unique: true
    t.index ["holiday_id"], name: "index_dates_holidays_on_holiday_id"
  end

  create_table "email_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "email_id", null: false
    t.bigint "postcard_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id", "postcard_id"], name: "index_email_cards_on_email_id_and_postcard_id", unique: true
    t.index ["email_id"], name: "index_email_cards_on_email_id"
    t.index ["postcard_id"], name: "index_email_cards_on_postcard_id"
  end

  create_table "email_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "email_id", null: false
    t.bigint "cardtext_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cardtext_id"], name: "index_email_texts_on_cardtext_id"
    t.index ["email_id", "cardtext_id"], name: "index_email_texts_on_email_id_and_cardtext_id", unique: true
    t.index ["email_id"], name: "index_email_texts_on_email_id"
  end

  create_table "emails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", default: ""
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "mail_address_id"
    t.integer "checkit"
    t.datetime "sent_date"
    t.date "will_send"
    t.text "message"
    t.bigint "holiday_id"
    t.integer "year", default: 0
    t.string "subject", default: ""
    t.integer "dates_holiday_id", default: 0
    t.integer "person_id", default: 0
    t.index ["address"], name: "index_emails_on_address"
    t.index ["holiday_id", "year", "person_id"], name: "index_emails_on_holiday_id_and_year_and_person_id", unique: true
    t.index ["holiday_id"], name: "index_emails_on_holiday_id"
    t.index ["mail_address_id"], name: "index_emails_on_mail_address_id"
  end

  create_table "holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "type_id"
    t.integer "calc"
    t.index ["name"], name: "index_holidays_on_name", unique: true
    t.index ["type_id"], name: "index_holidays_on_type_id"
  end

  create_table "mail_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: ""
    t.bigint "companies_person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["companies_person_id"], name: "index_mail_addresses_on_companies_person_id"
    t.index ["email"], name: "index_mail_addresses_on_email"
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", default: ""
    t.string "email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthday"
    t.integer "this_email_use"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["name"], name: "index_people_on_name", unique: true
  end

  create_table "postcards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "filename", default: ""
    t.binary "image", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.bigint "holiday_id"
    t.integer "once"
    t.index ["holiday_id"], name: "index_postcards_on_holiday_id"
  end

  create_table "types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_types_on_name"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false, null: false
    t.string "name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cardtexts", "holidays"
  add_foreign_key "companies", "countries"
  add_foreign_key "companies_holidays", "companies"
  add_foreign_key "companies_holidays", "holidays"
  add_foreign_key "companies_people", "companies"
  add_foreign_key "companies_people", "people"
  add_foreign_key "countries_holidays", "countries"
  add_foreign_key "countries_holidays", "holidays"
  add_foreign_key "dates_holidays", "holidays"
  add_foreign_key "email_cards", "emails"
  add_foreign_key "email_cards", "postcards"
  add_foreign_key "email_texts", "cardtexts"
  add_foreign_key "email_texts", "emails"
  add_foreign_key "emails", "holidays"
  add_foreign_key "holidays", "types"
  add_foreign_key "mail_addresses", "companies_people"
  add_foreign_key "postcards", "holidays"
end
