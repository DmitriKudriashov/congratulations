class Person < ApplicationRecord
  has_many :companies_people, dependent: :destroy
  has_many :companies, through: :companies_people

end
