# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :cardtexts, :filename, unique: true
    add_index :countries_holidays, %i[country_id holiday_id], unique: true
    add_index :companies_holidays, %i[company_id holiday_id], unique: true
    remove_column :emails, :company_id
  end
end
