class ApplicationController < ActionController::Base


  def greeting_mailer_send
    GreetingsMailer.send_message(params).deliver_now
    redirect_to root_path
  end



end
