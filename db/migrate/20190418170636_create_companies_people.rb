# frozen_string_literal: true

class CreateCompaniesPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :companies_people do |t|
      t.references :person, foreign_key: true, null: false

      t.timestamps
    end
  end
end
