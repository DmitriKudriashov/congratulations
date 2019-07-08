# frozen_string_literal: true

class RecreateUniqueIndexFromEmails < ActiveRecord::Migration[5.2]
  def change
    remove_index :emails, %i[holiday_id person_id]
    add_index :emails, %i[holiday_id person_id year], unique: true
  end
end
