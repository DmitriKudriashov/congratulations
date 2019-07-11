# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.per_page = 5
  scope :select_year, ->(y) { where(year: y) }
  scope :birthday, ->(date) { where("cast(strftime('%m', birthday) as int) = ? AND cast(strftime('%d', birthday) as int) = ?", date.month, date.day) }

  self.abstract_class = true

  def self.first_month
    dh = DatesHoliday.first
    dh.holiday.companies.first.people.first.dob_month
  end

  def self.emails_create
    first_month
  end
end
