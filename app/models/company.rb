class Company < ApplicationRecord
  belongs_to :country
  belongs_to :companies_person
end
