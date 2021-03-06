# frozen_string_literal: true

class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.string :name, index: { unique: true }, default: ''
      t.references :country, foreign_key: true, null: false

      t.timestamps
    end
  end
end
