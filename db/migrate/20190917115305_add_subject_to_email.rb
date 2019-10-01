# frozen_string_literal: true

class AddSubjectToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :subject, :string, default: ''
  end
end
