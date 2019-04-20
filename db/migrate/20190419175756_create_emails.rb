class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :address, default: "", null: false
      t.string :file_image, default: "", null: false
      t.timestamps
    end
  end
end
