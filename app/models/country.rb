# frozen_string_literal: true

class Country < ApplicationRecord
  has_many :countries_holidays, dependent: :restrict_with_error
  has_many :holidays, through: :countries_holidays

  has_many :companies, dependent: :restrict_with_error

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

end
