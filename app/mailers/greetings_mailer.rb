# frozen_string_literal: true

class GreetingsMailer < ApplicationMailer
  attr_reader :address

  def send_message(email, user)
    @name = email.name
    @address = Holiday.find(email.holiday_id).name == 'Birthday' ? personal_address(email) : company_mail_address(email)
    if address.nil?
      flash[:alert] = "Not found email for: #{email.person.name}!!! "
      return
    end

    @greetings_text = email.message
    @from = %("STAFF CENTRE" < #{user.email} >)
    @files = []
    email.postcards.each do |postcard|
      file_with_picture = postcard.image.path
      if File.exist?(file_with_picture)
        ext = get_image_extension(file_with_picture)
        attachments.inline[postcard.filename] = {
                                          mime_type: "image/#{ext}" ,
                                          content: File.read(file_with_picture)
                                          }
        @files << postcard.filename
      end
    end

    mail from: @from, to: address_checked, subject: email.subject
  end

  def personal_address(email)
    email.person.email.present? ? email.person.email : nil
  end

  def company_mail_address(email)
    email.mail_address_id.to_i.zero? ? personal_address(email) : email.mail_address.email
  end

  private

  def address_checked
    position = @address.index('@staff-centre.com').to_i
    position > 0 ? "#{@address[0..position]}staff-centre-com.pronov.net" : @address
  end

  def get_image_extension(local_file_path)
    png = 'x89PNG' # Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = 'xFF\xD8\xFF\xE0\x00\x10JFIF'  # Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
    jpg2 = 'xFF\xD8\xFF\xE1(.*){2}Exif' # Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
    case IO.read(local_file_path, 10)
    when /^GIF8/
      'gif'
    when "/^#{png}/"
      'png'
    when  "/^#{jpg}"
    when "/^#{jpg2}"
      'jpeg'
    else
      mime_type = `file #{local_file_path} --mime-type`.gsub("\n", '') # Works on linux and mac
    raise UnprocessableEntity, "unknown file type" if !mime_type
      mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
    end
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
