# frozen_string_literal: true

class ChangeStructureDatesHoliday < ActiveRecord::Migration[5.2]
  def change
    change_column_default :dates_holidays, :holiday_id, 0
  end
end
