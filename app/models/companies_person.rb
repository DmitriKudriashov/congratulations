class CompaniesPerson < ApplicationRecord
  belongs_to :companies
  belongs_to :person
end
