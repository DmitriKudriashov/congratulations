# frozen_string_literal: true

class CompaniesPerson < ApplicationRecord
  belongs_to :company
  belongs_to :person
  has_many :mail_addresses , dependent: :delete_all

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE

  def name_company_and_name_person
    "#{company.name}, #{person.name}"
  end
end
