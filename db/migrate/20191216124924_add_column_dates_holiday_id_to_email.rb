class AddColumnDatesHolidayIdToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :dates_holiday_id, :integer, default: 0
  end
end
