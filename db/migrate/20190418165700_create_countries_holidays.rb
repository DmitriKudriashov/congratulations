# frozen_string_literal: true

class CreateCountriesHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :countries_holidays do |t|
      t.references :country, foreign_key: true, null: false
      t.references :holiday, foreign_key: true, null: false

      t.timestamps
    end
  end
end
