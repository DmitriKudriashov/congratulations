# frozen_string_literal: true

class CompaniesPerson < ApplicationRecord
  belongs_to :company
  belongs_to :person

  def name_company_and_name_person
    "#{company.name}, #{person.name}"
  end

  def list_companies_people; end
end
