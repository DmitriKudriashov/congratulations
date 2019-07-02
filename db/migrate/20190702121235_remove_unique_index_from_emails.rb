class RemoveUniqueIndexFromEmails < ActiveRecord::Migration[5.2]
  def change
    remove_index :emails,  [:holiday_id, :person_id, :will_send]
    add_index :emails,  [:holiday_id, :person_id], unique: true
 end
end
