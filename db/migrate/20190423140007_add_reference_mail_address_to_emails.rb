class AddReferenceMailAddressToEmails < ActiveRecord::Migration[5.2]
  def change
    add_reference :emails, :mail_address, foreign_key: true
  end
end
