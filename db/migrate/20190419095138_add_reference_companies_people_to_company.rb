# frozen_string_literal: true

class AddReferenceCompaniesPeopleToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies_people, :company, foreign_key: true, on_delete: :cascade
    add_index :companies_people, %i[company_id person_id], unique: true
  end
end
