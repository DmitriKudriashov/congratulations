# frozen_string_literal: true

class AddNewFieldsToHoliday < ActiveRecord::Migration[5.2]
  def change
    add_column :holidays, :calc, :integer
    add_column :dates_holidays, :date, :date
    add_column :postcards, :once, :integer
  end
end
