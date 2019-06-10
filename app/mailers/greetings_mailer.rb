class GreetingsMailer < ApplicationMailer

  def send(email)
    @name = email.name
    @address = email.address
    @textmail = email.cardtext

    mail to: @address
  end
end
