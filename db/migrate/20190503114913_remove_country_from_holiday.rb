# frozen_string_literal: true

class RemoveCountryFromHoliday < ActiveRecord::Migration[5.2]
  def change
    remove_column :holidays, :country_id
  end
end
