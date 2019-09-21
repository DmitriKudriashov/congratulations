task :mails_send do
  current_user = User.first
  date = Date.today
  Email.emails_for_send(date).each do |email|
    email.send_now(current_user)
  end
end
