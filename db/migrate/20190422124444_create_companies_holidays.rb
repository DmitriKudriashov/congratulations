class CreateCompaniesHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :companies_holidays do |t|
      t.references :company, foreign_key: true, null: false
      t.references :holiday, foreign_key: true, null: false

      t.timestamps
    end
  end
end

