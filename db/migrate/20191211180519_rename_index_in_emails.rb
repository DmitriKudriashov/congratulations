class RenameIndexInEmails < ActiveRecord::Migration[5.2]
  def change
    rename_index :emails, "index_emails_on_holiday_id_and_person_id_and_year", "index_emails_on_holiday_id_and_year"
  end
end
