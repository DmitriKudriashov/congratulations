# frozen_string_literal: true

class GreetingsMailer < ApplicationMailer
  def send_message(email, user)
    @name = email.name
    @address = Holiday.find(email.holiday_id).name == 'Birthday' ? personal_address(email) : company_mail_address(email)
    if @address.nil?
      flash[:alert] = "Not found email for: #{email.person.name}!!! "
      return
    end

    @greetings_text = email.message
    @from = %("STAFF CENTRE" < #{user.email} >)
    # attachments = list_attachments(email) # почему-то не сработало ???
    @files = []
    email.postcards.each do |postcard|
      file_with_picture = postcard.image.path
      if File.exist?(file_with_picture)
        attachments[postcard.filename] = File.read(file_with_picture)
        # attachments[postcard.filename].mime_type = 'image/jpeg' #'image/gif'
        @files << postcard.filename
      end
    end
    # byebug

    mail from: @from, to: @address, subject: 'CONGRATULATIONS !!!' #, content_type: "text/html"
    email.sent_date = Time.now
    email.address = @address
    email.save
  # rescue StandardError => e
  #   flash[:alert] = " ERROR SAVE EMAIL ! #{e.message} "
  end

  def personal_address(email)
    email.person.email.present? ? email.person.email : nil
  end

  def company_mail_address(email)
    email.mail_address_id.to_i.zero? ? personal_address(email) : email.mail_address.email
  end

  def list_attachments(email)
    atts = {}

    email.postcards.each do |postcard|
      file_with_picture = postcard.image.path
      if File.exist?(file_with_picture)
        atts[postcard.filename] = File.read(file_with_picture)
      end
    end
    atts
  end
end
