class Holiday < ApplicationRecord
  has_many :countries_holidays, dependent: :destroy
  has_many :companies_holidays, dependent: :destroy
  belongs_to :type, dependent: :destroy
end
