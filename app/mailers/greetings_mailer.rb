# frozen_string_literal: true

class GreetingsMailer < ApplicationMailer
  attr_reader :address, :email, :user

  def send_message(email, companies_email,  user)
    @email = email
    @user = user
    @address = companies_email.present? ? companies_email.company.email : email.address
    if @address.present?
      send_email_to_recipient
    end
  end

  def send_email_to_recipient
    @greetings_text = email.message
    @from =  %("STAFF CENTRE" < crewing@staff.od.ua > )# 23/12/2020 #{user.email} >)
    @files = []
    email.postcards.each do |postcard|
      file_with_picture = postcard.image.path
      next unless File.exist?(file_with_picture)

      ext = get_image_extension(file_with_picture)
      attachments.inline[postcard.filename] = {
        mime_type: "image/#{ext}",
        content: File.read(file_with_picture)
      }
      @files << postcard.filename
    end

    # new_address = address_checked
    # if new_address == @address
    #   mail from: @from, to: new_address, subject: email.subject
    # else
    #   mail from: @from, to: address, bcc: new_address, subject: email.subject
    # end

    mail from: @from, to: address, subject: email.subject
  end

  def personal_address(email)
    email.person.email.present? ? email.person.email : nil
  end

  private

  def address_checked
    position = @address.index('@staff-centre.com').to_i
    position.eql?(0) ? @address : "#{@address[0..position]}staff-centre-com.pronov.net"
  end

  def get_image_extension(local_file_path)
    ext = File.extname(local_file_path)
    ext[1,ext.size]
  end
  # def get_image_extension(local_file_path)
  #   png = 'x89PNG' # Regexp.new("\x89PNG".force_encoding("binary"))
  #   jpg = 'xFF\xD8\xFF\xE0\x00\x10JFIF' # Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
  #   jpg2 = 'xFF\xD8\xFF\xE1(.*){2}Exif' # Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
  #   case IO.read(local_file_path, 10)
  #   when /^GIF8/
  #     'gif'
  #   when "/^#{png}/"
  #     'png'
  #   when "/^#{jpg}"
  #     'jpg'
  #   when "/^#{jpg2}"
  #     'jpeg'
  #   else
  #     mime_type = `file #{local_file_path} --mime-type`.gsub("\n", '') # Works on linux and mac
  #     raise UnprocessableEntity, 'unknown file type' unless mime_type

  #     mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
  #   end
  # end

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
