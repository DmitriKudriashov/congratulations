class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name, index: {unique: true},  default: ''
      t.references :country, foreign_key: true, null: false

      t.timestamps
    end
  end
end
