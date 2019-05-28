class Country < ApplicationRecord
  has_many :countries_holidays, dependent: :restrict_with_error
  has_many :holidays, through: :countries_holidays

  has_many :companies, dependent: :restrict_with_error
end
