class AddPrimaryKeyToCompaniesEmails < ActiveRecord::Migration[5.2]
  def change
    add_column :companies_emails, :id, :primary_key
  end
end
