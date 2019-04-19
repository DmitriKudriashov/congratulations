class CreatePeople < ActiveRecord::Migration[5.2]

  def change
    create_table :people do |t|
      t.string :name, index: {unique: true},  default: ''
      t.string :email, index: {unique: true},  default: ''
      t.references :country, foreign_key: true, null: false
      t.references :company, foreign_key: true, null: false

      t.timestamps
    end
  end
end
