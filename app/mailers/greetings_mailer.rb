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
    # @from = %("STAFF CENTRE" <office@staff-centre.com>)

    # attachments = list_attachments(email) # почему-то не сработало ???

    email.postcards.each do |postcard|
      file_with_picture = postcard.image.path
      if File.exist?(file_with_picture)
        attachments[postcard.filename] = File.read(file_with_picture)
      end
    end

    mail from: @from, to: @address, subject: 'CONGRATULATIONS !!!'
    email.sent_date = Time.now
    email.save
  rescue StandardError => e
    flash[:alert] = " ERROR SAVE EMAIL ! #{e.message} "
  end

  def personal_address(email)
    email.address.present? ? email.address : nil
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

  def send_message_old(email)
    @name = email.name
    @address = email.address
    @greetings_text = email.greetings_text
    @from = %("STAFF CENTRE" <office@staff-centre.com>)
    @postcard = email.postcards.first
    return unless @postcard.present?

    # @att_file = Rails.root.join("./public#{@postcard.image.url}")
    # <Pathname:
    # /Users/Admin/Sites/ROR/congratulations/public/system/postcards/images/000/000/003/original/Rob-Gonsalves-Master-of-Illusion-optical.jpg?1559820537>
    @att_file = @postcard.image.path
    if File.exist?(@att_file)
      attachments[@postcard.filename] = File.read(@att_file)
      mail from: @from, to: @address, subject: 'CONGRATULATIONS !!!'
    end
  end
end
