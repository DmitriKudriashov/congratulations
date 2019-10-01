require File.expand_path('../../../config/environment', __FILE__)

namespace :mails do
    desc 'Send emails with congratulations'
    task :send do
      current_user = User.first
      date = Date.today
      Email.emails_for_send(date).each do |email|
        email.send_now(current_user)
      end
    end
end












































 1Help            2Save             3Mark             4Replac           5Copy             6Move            7Search           8Delete           9PullDn          10Quit
