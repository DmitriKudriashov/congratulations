class CreateUniqueIndexOnEmails < ActiveRecord::Migration[5.2]
  def change
    add_index :emails,  [:holiday_id, :person_id, :will_send], unique: true
  end
end
