class Company < ApplicationRecord
  belongs_to :country
  has_many :companies_people, dependent: :restrict_with_exception
  has_many :people, through: :companies_people

  has_many :companies_holidays, dependent: :restrict_with_exception
  has_many :holidays, through: :companies_holidays


end
