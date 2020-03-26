# frozen_string_literal: true

module ApplicationHelper
  include CompaniesPeopleHelper

  def flash_messages
    flash.map do |key, message|
      key = key.eql?('alert') ? 'danger' : 'info'
      content_tag :div, message, class: "alert alert-#{key}"
    end
         .join("\n").html_safe
  end

  def modify_name(name)
    arr_name = name.split(' ')
    new_name ||= arr_name[0].to_s
    new_name = new_name + ' ' + arr_name[1][0] + '.' if arr_name[1].present?
    new_name = new_name + ' ' + arr_name[2][0] + '.' if arr_name[2].present?
    new_name
  end

  def check_email
    check_current_user
  end

  private

  def check_current_user
    current_user.admin
  end
end
