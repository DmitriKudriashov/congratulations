# frozen_string_literal: true

class Company < ApplicationRecord
  belongs_to :country
  has_many :companies_people, dependent: :restrict_with_error
  has_many :people, through: :companies_people

  has_many :companies_holidays, dependent: :restrict_with_error
  has_many :holidays, through: :companies_holidays

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

  # has_and_belongs_to_many :holidays
end
