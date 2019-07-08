# frozen_string_literal: true

class CreateUniqueIndexOnEmails < ActiveRecord::Migration[5.2]
  def change
    add_index :emails, %i[holiday_id person_id will_send], unique: true
  end
end
