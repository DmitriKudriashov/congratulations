# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_cards, dependent: :restrict_with_error
  has_many :postcards, through: :email_cards

  has_many :email_texts, dependent: :restrict_with_error
  has_many :cardtexts, through: :email_texts

  belongs_to :mail_address
  belongs_to :holiday
  belongs_to :person

  def greetings_text
    cardtexts.first.present? ? cardtexts.first.text : 'Text not avalable !'
  end

  def self.new_emails_to_date(_date)
    dh = DatesHoliday.first
    dh.holiday.companies.first.people.first.dob_month
  end
end
