# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name, default: '', index: { unique: true }
      t.string :code, default: '', index: { unique: true }

      t.timestamps
    end
  end
end
