class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :cardtexts, :filename, unique: true
    add_index :countries_holidays, [:country_id, :holiday_id], unique: true
    add_index :companies_holidays, [:company_id, :holiday_id], unique: true
    remove_column :emails, :company_id
    # remove_index :emails, name: "index_emails_on_company_id"
  end
end
