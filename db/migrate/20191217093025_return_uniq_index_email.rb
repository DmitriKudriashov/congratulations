class ReturnUniqIndexEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :emails, [:holiday_id, :year, :person_id], unique: true
  end
end
