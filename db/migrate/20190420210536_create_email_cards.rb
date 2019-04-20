class CreateEmailCards < ActiveRecord::Migration[5.2]
  def change
    create_table :email_cards do |t|

      t.timestamps
    end
  end
end
