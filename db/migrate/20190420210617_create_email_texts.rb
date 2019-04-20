class CreateEmailTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :email_texts do |t|

      t.timestamps
    end
  end
end
