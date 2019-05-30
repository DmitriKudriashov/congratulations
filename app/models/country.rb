class Country < ApplicationRecord
  has_many :countries_holidays, dependent: :destroy
  has_many :holidays, through: :countries_holidays

  has_many :companies, dependent: :destroy
end
