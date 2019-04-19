class Country < ApplicationRecord
  has_many :countries_holidays, dependent: :destroy
  has_many :companies, dependent: :destroy
end
