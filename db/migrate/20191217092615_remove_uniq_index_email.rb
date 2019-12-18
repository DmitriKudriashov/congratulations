class RemoveUniqIndexEmail < ActiveRecord::Migration[5.2]
  def change
    remove_index :emails, column: [:dates_holiday_id, :year]
  end
end
