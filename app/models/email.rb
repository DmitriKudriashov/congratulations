# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_cards, dependent: :delete_all
  has_many :postcards, through: :email_cards

  has_many :email_texts, dependent: :delete_all
  has_many :cardtexts, through: :email_texts

  has_many :company, through: :companies_emails
  belongs_to :holiday
  has_many :companies_emails, dependent: :delete_all
  #[:destroy, :delete_all, :nullify, :restrict_with_error, :restrict_with_exception],

  attr_reader :error_sent

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE

  scope :emails_for_send, ->(date) { where(will_send: date, checkit: 1, sent_date: nil) }

  # def greetings_text
  #   message
  #   # cardtexts.first.present? ? cardtexts.first.text : 'Text not avalable !'
  # end

  # def self.new_emails_to_date(_date)
  #   dh = DatesHoliday.first
  #   dh.holiday.companies.first.people.first.dob_month
  # end

  def send_now(current_user)
    return if self.will_send > Date.today
    @error_sent = nil
    self.companies_emails.each do |companies_email|

      new_mail = GreetingsMailer.send_message(self, companies_email, current_user)
      begin
        new_mail.deliver_now!
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        return @error_sent
      else
        self.sent_date = Time.now
        self.address = new_mail[:to]
        save
      end
    end
  end

  def set_email_fields(opt = {})
    fill_new(opt)
  end

  private

  def fill_new(opt = {})
    self.name = opt[:name]
    self.holiday_id = opt[:holiday_id]
    self.address = opt[:address]
    self.mail_address_id = opt[:mail_address_id]
    self.checkit = opt[:checkit]
    self.will_send = opt[:will_send]
    self.message = opt[:message]
    # self.person_id = opt[:person_id]
    self.year = opt[:year]
    self.subject = opt[:subject]
  end
end
