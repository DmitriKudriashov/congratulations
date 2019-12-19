class RedoUniqIndexEmail < ActiveRecord::Migration[5.2]
  def change
    remove_index :emails, column: [:holiday_id, :year]
  end
end
