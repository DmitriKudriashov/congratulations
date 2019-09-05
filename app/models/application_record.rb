# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  $PER_PAGE = 7
  self.per_page = $PER_PAGE
  scope :select_year, ->(y) { where(year: y) }
  scope :birthday, ->(date) { where("month(birthday) = ? AND day(birthday) = ?", date.month, date.day) }

  self.abstract_class = true

  def self.first_month
    dh = DatesHoliday.first
    dh.holiday.companies.first.people.first.dob_month
  end

  def self.emails_create
    first_month
  end
end
