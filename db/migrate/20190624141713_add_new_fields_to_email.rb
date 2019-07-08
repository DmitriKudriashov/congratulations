# frozen_string_literal: true

class AddNewFieldsToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :will_send, :date
    add_column :emails, :message, :text, defalult: ''
    add_reference :emails, :holiday, foreign_key: true
  end
end
