class Person < ApplicationRecord
  has_many :companies_people, dependent: :restrict_with_exception
  has_many :companies, through: :companies_people

end
