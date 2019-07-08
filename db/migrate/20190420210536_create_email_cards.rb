# frozen_string_literal: true

class CreateEmailCards < ActiveRecord::Migration[5.2]
  def change
    create_table :email_cards do |t|
      t.references :email, foreign_key: true, null: false
      t.references :postcard, foreign_key: true, null: false
      t.index %i[email_id postcard_id], unique: true
      t.timestamps
    end
  end
end
