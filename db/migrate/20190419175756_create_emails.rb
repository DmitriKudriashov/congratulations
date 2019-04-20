class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :address, default: "", null: false
      t.references :company, foreign_key: true, null: false
      t.timestamps
    end
  end
end
