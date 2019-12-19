class CreateNewUqIndexEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :emails, [:dates_holiday_id, :year], unique: true
  end
end
