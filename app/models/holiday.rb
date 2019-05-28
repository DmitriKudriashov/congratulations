class Holiday < ApplicationRecord
  has_many :countries_holidays, dependent: :restrict_with_error
  has_many :countries, through: :countries_holidays

  has_many :companies_holidays, dependent: :restrict_with_error
  has_many :companies, through: :companies_holidays

  has_many :dates_holidays, dependent: :restrict_with_error
  belongs_to :type
end
