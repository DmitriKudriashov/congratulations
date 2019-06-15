class GreetingsMailer < ApplicationMailer

  def send_message(email)
    @name = email.name
    @address = email.address
    # @greetings_text = email.greetings_text
    mail to: @address, subject: "CON-GRATULATIONS !!!"
  end

end
