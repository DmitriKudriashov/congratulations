# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  $Period = 25

  $PER_PAGE = 12
  self.per_page = $PER_PAGE
  scope :select_year, ->(y) { where(year: y) }

  self.abstract_class = true

  def self.first_month
    dh = DatesHoliday.first
    dh.holiday.companies.first.people.first.dob_month
  end

  def self.emails_create
    first_month
  end
end

