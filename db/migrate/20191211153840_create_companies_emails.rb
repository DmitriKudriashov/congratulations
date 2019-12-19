class CreateCompaniesEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :companies_emails, id: false do |t|
      t.bigint :email_id
      t.bigint :company_id
    end
  end
end
