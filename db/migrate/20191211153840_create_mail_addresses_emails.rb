class CreateMailAddressesEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :mail_addresses_emails, id: false do |t|
      t.bigint :email_id
      t.bigint :mail_address_id
    end
  end
end
