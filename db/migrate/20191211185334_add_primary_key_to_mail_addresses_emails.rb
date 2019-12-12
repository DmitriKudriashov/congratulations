class AddPrimaryKeyToMailAddressesEmails < ActiveRecord::Migration[5.2]
  def change
    add_column :mail_addresses_emails, :id, :primary_key
  end
end
