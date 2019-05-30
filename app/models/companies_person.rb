class CompaniesPerson < ApplicationRecord
  belongs_to :company
  belongs_to :person


  def name_company_and_name_person
    "#{self.company.name}, #{self.person.name}"
  end

  def list_companies_people

  end
end

