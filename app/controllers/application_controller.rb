# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # def greeting_mailer_send
  #   GreetingsMailer.send_message(params).deliver_now
  #   redirect_to root_path
  # end

  def list_holidays_to_date(day, month)
    Holiday.where(day: day, month: month)
  end

  def lis_companies_people_to_holiday(holiday); end

  def list_people_birthday(date); end

  def list_pervious_email(person); end
end
