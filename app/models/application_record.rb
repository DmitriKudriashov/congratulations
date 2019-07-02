class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # scope :holidays_to_date, ->(day, month, year) { where("day = ? and month = ? and year = ?", day, month, year) }


  def self.first_month
    dh = DatesHoliday.first
    dh.holiday.companies.first.people.first.dob_month
  end
  def self.emails_create
    self.first_month
  end
end
