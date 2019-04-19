class Holiday < ApplicationRecord
  has_many :countries_holidays, dependent: :destroy
end
