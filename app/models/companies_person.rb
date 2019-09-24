# frozen_string_literal: true

class CompaniesPerson < ApplicationRecord
  belongs_to :company
  belongs_to :person
  has_many :mail_addresses, dependent: :restrict_with_error

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

  def name_company_and_name_person
    "#{company.name}, #{person.name}"
  end

  def list_companies_people; end
end
