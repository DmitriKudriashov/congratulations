# frozen_string_literal: true

class DatesHoliday < ApplicationRecord
  belongs_to :holiday

  MONTHNAMES = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July',
                'August', 'September', 'October', 'November', 'December'].freeze
  scope :holidays_to_date, ->(day, month, year) { where(day: day, month: month, year: year) }

  def list_companies
    holiday.companies
  end

  def self.company_name(holiday_id)
    holiday = Holiday.where('id = ?', holiday_id).first

    return '---' if holiday.nil?

    holiday.name
  end

  def self.list_to_day(day, month)
    holidays_to_date(day, month, 0)
  end

  def name_month
    MONTHNAMES[month]
  end

  def name_of_company
    list =  ''
    holiday = self.holiday
    if holiday.present?
      holiday_companies = holiday.companies_holidays.where('holiday_id = ?', holiday_id)
      holiday_companies.map do |holiday_company|
        list += holiday_company.present? ? "#{holiday_company.company.name}; \n" : ''
      end
    end
    list
  end

  def list_people
    list = ''
    holiday = self.holiday
    if holiday.present?
      holiday_companies = holiday.companies_holidays.where('holiday_id = ?', holiday_id)
      holiday_companies.map do |holiday_company|
        next unless holiday_company.present?

        people = holiday_company.company.people

        people.map do |person|
          list += person.present? ? "#{person.name}; \n" : ''
        end
      end
    end
    list
  end

  def self.easter(year)
    c = year / 100
    n = year - 19 * (year / 19)
    k = (c - 17) / 25
    i = c - c / 4 - (c - k) / 3 + 19 * n + 15
    i -= 30 * (i / 30)
    i -= (i / 28) * (1 - (i / 28) * (29 / (i + 1)) * ((21 - n) / 11))
    j = year + year / 4 + i + 2 - c + c / 4
    j -= 7 * (j / 7)
    l = i - j
    month = 3 + (l + 40) / 44
    day = (28 + l) - 31 * (month / 4)
    [month, day]
  end
end
