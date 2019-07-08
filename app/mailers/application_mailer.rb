# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: %("From Dmitriy" <kds.120731@gmail.com>)
  layout 'greetings_mailer'
end
