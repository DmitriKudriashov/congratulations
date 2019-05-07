class CreateDatesHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :dates_holidays do |t|
      t.integer  :day, null: false, default: 1
      t.integer  :month, null: false, default: 1
      t.integer  :year, null: false, default: 0
      t.references :holiday, foreign_key: true, null: false
      t.timestamps
    end
    add_index :dates_holidays, [:holiday_id, :day, :month, :year], unique: true
  end
end
