class Holiday < ApplicationRecord
  has_many :countries_holidays, dependent: :restrict_with_exception
  has_many :countries, through: :countries_holidays

  has_many :companies_holidays, dependent: :restrict_with_exception
  has_many :companies, through: :companies_holidays

  has_many :dates_holidays, dependent: :restrict_with_exception
  belongs_to :type
end
