class RemoveReferencePersonToEmail < ActiveRecord::Migration[5.2]
  def change
    remove_index :emails, name: "index_emails_on_person_id"
    remove_index  :emails, name: "index_emails_on_holiday_id_and_person_id_and_year"
    remove_reference :emails, :person, foreign_key: false
  end
end
