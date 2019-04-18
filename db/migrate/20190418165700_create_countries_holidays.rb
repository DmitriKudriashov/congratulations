class CreateCountriesHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :countries_holidays do |t|

      t.timestamps
    end
  end
end
