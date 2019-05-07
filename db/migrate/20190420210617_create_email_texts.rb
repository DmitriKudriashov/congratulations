class CreateEmailTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :email_texts do |t|
      t.references :email, foreign_key: true, null: false
      t.references :cardtext, foreign_key: true, null: false
      t.index [:email_id, :cardtext_id], unique: true
      t.timestamps
    end
  end
end
