# frozen_string_literal: true

class Email < ApplicationRecord
  has_many :email_cards, dependent: :restrict_with_error
  has_many :postcards, through: :email_cards

  has_many :email_texts, dependent: :restrict_with_error
  has_many :cardtexts, through: :email_texts

  belongs_to :mail_address
  belongs_to :holiday
  belongs_to :person
  attr_reader :error_sent

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE


  scope :emails_for_send, -> (date){ where(will_send: date, checkit: 1, sent_date: nil )}

  def greetings_text
    message
    # cardtexts.first.present? ? cardtexts.first.text : 'Text not avalable !'
  end

  def self.new_emails_to_date(_date)
    dh = DatesHoliday.first
    dh.holiday.companies.first.people.first.dob_month
  end

  def send_now(current_user)
    @error_sent = nil
      new_mail = GreetingsMailer.send_message(self, current_user)
      # return if new_mail[:to].nil?
      begin
        new_mail.deliver_now!
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => @error_sent
        return @error_sent
      else
        self.sent_date = Time.now
        self.address = new_mail[:to]
        self.save
      end
  end
end
