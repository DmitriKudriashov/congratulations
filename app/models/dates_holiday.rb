# frozen_string_literal: true

class DatesHoliday < ApplicationRecord
  belongs_to :holiday

  validates :date, presence: true

  MONTHNAMES = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July',
                'August', 'September', 'October', 'November', 'December'].freeze
  scope :holidays_to_date, ->(day, month, year) { where(day: day, month: month, year: year) }
  scope :holiday_to_date, ->(holiday_id, day, month, year) { holidays_to_date(day, month, year).where(holiday_id: holiday_id) }
  validates_uniqueness_of :holiday_id, scope: %i[day month year], message: 'is not available'

  def save
    set_day_month_year
    super if valid?
  end

  def set_day_month_year
    self.day = 0
    self.month = 0
    if date.present?
      self.day = date.day
      self.month = date.month
      self.year = holiday.calc.present? ? date.year : 0
    end
  end

  def update(params)
    date = params[:date].to_date
    self.day = date.day
    self.month = date.month
    self.year = holiday.calc.present? ? date.year : 0
    super(params) if valid?
  end

  def name_month
    MONTHNAMES[month]
  end

  def self.create_date_holiday(date, holiday)
    year = holiday.calc.nil? ? 0 : date.year

    find_or_create_by(
      day: date.day,
      month: date.month,
      year: year,
      holiday_id: holiday.id,
      date: date
    )
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
      list = if holiday.name.eql?('Birthday')
               list_birthdays(day, month, list)
             else
               list_people_companies(holiday, list)
             end
    end
    list
  end

  def list_people_names(people, list)
    people.map do |person|
      list += person.present? ? "#{person.name}; \n" : ''
    end
    list
  end

  def list_people_companies(holiday, list)
    holiday_companies = holiday.companies_holidays.where('holiday_id = ?', holiday_id)
    holiday_companies.map do |holiday_company|
      next unless holiday_company.present?

      people = holiday_company.company.people
      list = people.present? ? list_people_names(people, list) : list
    end
    list
  end

  def list_birthdays(day, month, list)
    people = Person.birthdays_to_date(day, month)

    list = people.present? ? list_people_names(people, list) : list
  end

  def self.easter(year)
    c = year / 100 # k = целая часть (год/100)
    n = year - 19 * (year / 19) # a = год mod 19
    k = (c - 17) / 25 #
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

  def self.pasha(y)
    a = y % 19
    # puts "a = #{a}"

    b = y % 4
    # puts "b = #{b}"

    c = y % 7
    # puts "c = #{c}"

    k = y / 100
    # puts "k = #{k}"

    pp =  (13 + 8 * k) / 25
    # puts "p = #{pp}"

    q = k / 4
    # puts "q = #{q}"

    m = (15 - pp + k - q) % 30
    # puts "m = #{m}"

    n = (4 + k - q) % 7
    # puts "n = #{n}"

    d = (19 * a + m) % 7
    # puts "d = #{d}"

    e = (2 * b + 4 * c + 6 * d + n) % 7
    # puts "e = #{e}"

    # Дата Пасхи по новому стилю: 22 + d + e марта или d + e − 9 апреля
    d1 = 22 + e + d
    # puts "d1 = #{d1}"

    d2 = d + e - 9
    # puts "d2 = #{d2}"

    if d1 > 0
      day = d1
      month = 3
    else
      day = d2
      month = 4
    end
    # Если d = 29 и e = 6, то вместо 26 апреля будет 19 апреля
    if d.eql?(29) && e.eql?(6)
      day = 19
      month = 4
    end
    # Если d = 28, e = 6 и (11M + 11) mod 30 < 19, то вместо 25 апреля будет 18 апрел
    if d.eql?(28) && e.eql?(6) && (11 * m + 11) % 30 < 19
      day = 18
      month = 4
    end
    [day, month]
  end

  def self.pasha_prav(y)
    # Для определения даты Православной пасхи по старому стилю необходимо:

    # Разделить номер года на 19 и определить остаток от деления a.
    a = y % 19
    # puts "a = #{a}"

    # Разделить номер года на 4 и определить остаток от деления b.
    b = y % 4
    # puts "b = #{b}"

    # Разделить номер года на 7 и определить остаток от деления c.
    c = y % 7
    # puts "c = #{c}"

    # Разделить сумму 19a + 15 на 30 и определить остаток d.
    d = (19 * a + 15) % 30
    # puts "d = #{d}"

    # Разделить сумму 2b + 4c + 6d + 6 на 7 и определить остаток e.
    e = (2 * b + 4 * c + 6 * d + 6) % 7
    # puts "e = #{e}"

    # Определить сумму f = d + e.
    f = d + e
    # puts "f = #{f}"

    # (по старому стилю) Если f ≤ 9, то Пасха будет праздноваться 22 + f марта; если f > 9, то Пасха будет праздноваться f — 9 апреля.
    # if f <= 9
    #   day = 22 + f
    #   month = 3
    # else
    #   day = f - 9
    #   month = 4
    # end
    # # puts "1) day: #{day}, month: #{month}"

    # (по новому стилю) Если f ≤ 26, то Пасха будет праздноваться 4 + f апреля; если f > 26, то Пасха будет праздноваться f — 26 мая.
    if f <= 26
      day = 4 + f
      month = 4
    else
      day = f - 26
      month = 5
    end
    # puts "2) day: #{day}, month: #{month}"
    [day, month]
  end
end
