class CreateCompaniesHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :companies_holidays do |t|

      t.timestamps
    end
  end
end
