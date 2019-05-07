class AddReferenceCompaniesPeopleToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies_people, :company,  foreign_key: true,  on_delete: :cascade
    add_index :companies_people,  [:company_id, :person_id ], unique: true
  end
end
