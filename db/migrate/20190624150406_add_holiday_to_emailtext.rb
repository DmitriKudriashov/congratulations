class AddHolidayToEmailtext < ActiveRecord::Migration[5.2]
  def change
    add_reference :cardtexts, :holiday, foreign_key: true
    add_reference :postcards, :holiday, foreign_key: true
  end
end
