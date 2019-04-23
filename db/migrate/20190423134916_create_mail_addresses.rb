class CreateMailAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :mail_addresses do |t|
      t.string :email, default: "" , index: :unique
      t.references :companies_person, foreign_key: true, null: false
      t.timestamps
    end
  end
end
