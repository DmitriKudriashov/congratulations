# frozen_string_literal: true

class AddBirthdayToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :birthday, :date
  end
end
