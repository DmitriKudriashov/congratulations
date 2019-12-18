# frozen_string_literal: true

class Person < ApplicationRecord

  FOR_30_DAYS_SAME_YEARS = '((day(birthday) >= ? and month(birthday) = ?) or month(birthday) > ? )
  and ((day(birthday) <= ? and month(birthday) = ?) or month(birthday) < ? )'.freeze

  FOR_30_DAYS_DIFFERENT_YEARS = '((day(birthday) <= ? and month(birthday) = ?) or month(birthday) < ? ) or ((day(birthday) >= ? and month(birthday) = ?) or month(birthday) > ? )'.freeze


  has_many :companies_people, dependent: :restrict_with_error
  has_many :companies, through: :companies_people
  has_many :emails #, ->{ where "person_id > 0" } #dependent: :restrict_with_error

  scope :selectmonth, ->(m) { where('month(birthday) = ?', m) }
  scope :birthday_men, ->(date) { where('birthday = ?', date) }
  scope :selectid, ->(id) { where(id: id) }
  scope :birthdays_to_date,
        ->(day, month) { where('month(birthday) = ? and day(birthday) = ? ', month, day) }
  scope :birthdays_in_period, ->(from_date, to_date){ where(
      "(#{FOR_30_DAYS_SAME_YEARS} AND ? = ?) OR ((#{FOR_30_DAYS_DIFFERENT_YEARS}) AND ? < ? )",
      from_date.day, from_date.month, from_date.month, to_date.day, to_date.month, to_date.month,from_date.year, to_date.year,
      to_date.day, to_date.month, to_date.month, from_date.day, from_date.month, from_date.month,from_date.year, to_date.year
    )
  }

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE

  def birthday_format
    birthday.nil? ? '' : birthday.strftime('%d-%m-%Y')
  end

  def dob_month
    birthday.month
  end

end

# (
#   ((day(birthday) <= 18 and month(birthday) = 1) or month(birthday) < 1 )
#   or
#   ((day(birthday) >= 19 and month(birthday) = 12) or month(birthday) > 12 ) AND 15 < 16 )

# )


# (
#   (((day(birthday) >= 19 and month(birthday) = 12) or month(birthday) > 12 )
#   and ((day(birthday) <= 18 and month(birthday) = 1) or month(birthday) < 1 ) AND 15 = 16)
#   OR
#   ((((day(birthday) <= 18 and month(birthday) = 1) or month(birthday) < 1 ) or
#     ((day(birthday) >= 19 and month(birthday) = 12) or month(birthday) > 12 ) )
#     AND 15 < 16 ))
