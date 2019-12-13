# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def list_holidays_to_date(day, month)
    Holiday.where(day: day, month: month)
  end

  def lis_companies_people_to_holiday(holiday); end

  def list_people_birthday(date); end

  def list_pervious_email(person); end

  def destroy_common(object)
    if object.destroy
      flash[:notice] = "Record #{object.id} of #{object.model_name.name} was successfully Destroy!"
    else
      err = object.errors.messages[:base].first
      flash[:alert] = "Error destroy: #{object.model_name.name},  record:  #{object.id}. #{err}!"
    end
    err
    # begin
    #   object.destroy!
    # rescue ActiveRecord::RecordNotDestroyed => e
    #   flash[:alert] = "Error destroy: #{e.message}."
    # else
    #   flash[:notice] = "Record #{object.id} of #{object.model_name.name} was successfully Destroy!"
    # end
  end
end
