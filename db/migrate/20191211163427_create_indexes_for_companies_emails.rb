class CreateIndexesForCompaniesEmails < ActiveRecord::Migration[5.2]
  def change
    add_index :companies_emails, :email_id
    add_index :companies_emails, :company_id
  end
end
