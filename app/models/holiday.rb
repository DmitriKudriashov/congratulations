# frozen_string_literal: true

class Holiday < ApplicationRecord
  has_many :countries_holidays #, dependent: :restrict_with_error
  has_many :countries #, through: :countries_holidays

  has_many :companies_holidays#, dependent: :restrict_with_error
  has_many :companies #, through: :companies_holidays

  has_many :dates_holidays#, dependent: :restrict_with_error
  belongs_to :type

  has_many :cardtexts, dependent: :restrict_with_error
  has_many :postcards, dependent: :restrict_with_error
  has_many :emails, dependent: :restrict_with_error # validate: false

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
