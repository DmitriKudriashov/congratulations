class ChangeCompanyPeople < ActiveRecord::Migration[5.2]
  def change
    change_column_default :companies_people, :person_id, 0
  end
end
