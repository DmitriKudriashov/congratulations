class AddReferenceTypeToHolidays < ActiveRecord::Migration[5.2]
  def change
     add_reference :holidays, :type, foreign_key: true
  end
end
