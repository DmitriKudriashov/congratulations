class CreateIndexesForMailAddressesEmails < ActiveRecord::Migration[5.2]
  def change
    add_index :mail_addresses_emails, :email_id
    add_index :mail_addresses_emails, :mail_address_id
  end
end
