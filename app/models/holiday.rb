class Holiday < ApplicationRecord
  has_many :countries_holidays, dependent: :destroy
  has_many :countries, through: :countries_holidays

  has_many :companies_holidays, dependent: :destroy
  has_many :companies, through: :companies_holidays

  has_many :dates_holidays, dependent: :destroy
  belongs_to :type, dependent: :destroy
end
