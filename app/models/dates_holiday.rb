class DatesHoliday < ApplicationRecord
  belongs_to :holiday

  MONTHNAMES = ["","January","February","March","April","May","June","July",
                "August", "September", "October", "November", "December" ].freeze

  def list_companies
    self.holiday.companies
  end

  def self.company_name(holiday_id)
    holiday = Holiday.where("id = ?", holiday_id).first

    return '---' if holiday.nil?
    holiday.name
  end
  def name_month
    MONTHNAMES[self.month]
  end
  def name_of_company
    list =  ''
    holiday = self.holiday
    if holiday.present?
      holiday_companies = holiday.companies_holidays.where("holiday_id = ?", self.holiday_id)
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
      holiday_companies = holiday.companies_holidays.where("holiday_id = ?", self.holiday_id)
      holiday_companies.map do |holiday_company|
        if holiday_company.present?
          people = holiday_company.company.people

          people.map do |person|
            list += person.present? ? "#{person.name}; \n" : ''
          end
        end
      end
    end
    list
  end

end
