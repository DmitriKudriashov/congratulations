# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :companies_people, dependent: :restrict_with_error
  has_many :companies, through: :companies_people
  has_many :emails, dependent: :restrict_with_error

  scope :selectmonth, ->(m) { where("cast(strftime('%m', birthday) as int) = ?", m) }
  scope :birthday_men, ->(date) { where('birthday = ?', date) }
  scope :selectid, ->(id) { where(id: id) }

  def birthday_form
    birthday.nil? ? 'dd-mm-yyyy' : birthday.strftime('%d-%m-%Y')
  end

  def birthday_index
    birthday.nil? ? '' : birthday.strftime('%d-%m-%Y')
  end

  def dob_month
    birthday.month
  end
end
