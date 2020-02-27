# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_cards, dependent: :delete_all
  has_many :postcards, through: :email_cards

  has_many :email_texts, dependent: :delete_all
  has_many :cardtexts, through: :email_texts
  belongs_to :holiday

  # has_many :company, through: :companies_emails       # 130220
  has_many :companies_emails, dependent: :delete_all  # 130220

  #[:destroy, :delete_all, :nullify, :restrict_with_error, :restrict_with_exception],

  attr_reader :error_sent, :count_successfully, :count_total, :current_user

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE

  scope :emails_for_send, ->(date) { where(will_send: date, checkit: 1, sent_date: nil) }

  def send_now(user)
    return unless user.present?
    @current_user = user
    @count_successfully = 0
    @count_total = 0
    return if self.will_send > Date.today || self.sent_date.present?

    @error_sent = nil

    self.companies_emails.present? ? send_greeting_by_holiday : send_birthday_greeting

    save_sent_date if send_sucsessfuly?
  end

  def self.check(opt = {})
    e = self.new
    e.new_for_check(opt)
  end

  def set_email_fields(opt = {})
    fill_new(opt)
  end

  private

  def send_greeting_by_holiday
    self.companies_emails.each do |companies_email|
      if companies_email.company_id.present?
        company = Company.find(companies_email.company_id)
        if company.email.present? && !companies_email.comment.present?
          @count_total += 1
          @new_mail = new_email_send(companies_email)
          @count_successfully += 1 if @new_mail.present?
        end
      end
    end
  end

  def new_email_send(companies_email)
    new_mail = GreetingsMailer.send_message(self, companies_email, current_user)
    begin
      new_mail.deliver_now
      # HTTPError, HTTPFatalError, HTTPRetriableError, HTTPServerException
      # HTTPGenericRequest, HTTPResponse
    rescue Net::SMTPAuthenticationError,
           Net::SMTPFatalError,
           Net::SMTPServerBusy,
           Net::SMTPSyntaxError,
           Net::SMTPUnknownError,
           Net::SMTPUnsupportedCommand => @error_sent

      companies_email.comment = @error_sent if companies_email.present?
      new_mail = nil
    else
      companies_email.comment = Time.now  if companies_email.present?
    end
    companies_email.save  if companies_email.present?
    new_mail
  end

  def send_birthday_greeting
    @count_total += 1
    @new_mail = new_email_send(nil)
    if @new_mail.present?
      @count_successfully += 1
    end
  end

  def send_sucsessfuly?
    @count_total == @count_successfully && @count_successfully > 0 ? true : false
  end

  def save_sent_date
    return if @new_mail[:to].nil?
    self.sent_date = Time.now
    self.address = @count_successfully == 1 && @count_total == 1 && @new_mail[:to].present? ? @new_mail[:to] : 'Without address '
    self.save
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

  def new_for_check(opt = {})
    set_email_fields(opt)
    self.save
    self
  end
end
