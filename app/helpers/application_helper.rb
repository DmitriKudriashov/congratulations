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
    new_name ||= arr_name[0]
    new_name = new_name + ' ' + arr_name[1][0] + '.' if arr_name[1][0].present?
    new_name = new_name + ' ' + arr_name[2][0] + '.' if arr_name[2][0].present?
  end

end
