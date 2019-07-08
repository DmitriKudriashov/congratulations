# frozen_string_literal: true

class AddPersonIdToEmail < ActiveRecord::Migration[5.2]
  def change
    add_reference :emails, :person, foreign_key: true
  end
end
