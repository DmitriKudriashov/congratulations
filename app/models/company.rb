class Company < ApplicationRecord
  belongs_to :country
  has_many :companies_people
  has_many :companies_holidays
end
