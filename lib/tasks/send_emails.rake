# frozen_string_literal: true
require File.expand_path('../../config/environment', __dir__)

namespace :mails do
  desc 'Send emails with congratulations'
  task :send do
    # current_user = User.first
    current_user = User.where(email: "victoria.gavrilenko@staff.od.ua").first
    current_user = User.first unless current_user.present?
    date = Date.today
    Email.emails_for_send(date).each do |email|
      email.send_now(current_user) if email.sent_date.nil?
    end
  end
end
