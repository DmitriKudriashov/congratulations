# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_cards, dependent: :delete_all
  has_many :postcards, through: :email_cards

  has_many :email_texts, dependent: :delete_all
  has_many :cardtexts, through: :email_texts

  has_many :company, through: :companies_emails
  belongs_to :holiday
  # belongs_to :person
  has_many :companies_emails, dependent: :delete_all
  #[:destroy, :delete_all, :nullify, :restrict_with_error, :restrict_with_exception],

  attr_reader :error_sent

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE

  scope :emails_for_send, ->(date) { where(will_send: date, checkit: 1, sent_date: nil) }

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

  def self.check(opt = {})
    e = self.new

    e.new_for_check(opt)
  end
  def self.opt
    opt = {}
    opt[:name]  = ''
    opt[:holiday_id] = 8
    opt[:address] = 'asdsa@www.com'
    opt[:mail_address_id] = 0
    opt[:checkit] = 0
    opt[:will_send] = Date.today
    opt[:message] = 'MESSAGE'
    opt[:person_id] = 1
    opt[:year] = 2019
    opt[:subject] = 'subject qqqqq'
    opt[:dates_holiday_id] = 0
    opt
  end
  def new_for_check(opt = {})
    set_email_fields(opt)
    self.save
    self
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
    self.person_id = opt[:person_id]
    self.year = opt[:year]
    self.subject = opt[:subject]
    self.dates_holiday_id = opt[:dates_holiday_id]
  end
end
