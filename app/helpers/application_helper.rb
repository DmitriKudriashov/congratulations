module ApplicationHelper

   include CompaniesPeopleHelper

  def flash_messages
    flash.map do |key, message|
      key = key == 'alert' ? 'danger' : 'info'
      content_tag :div, message, class: "alert alert-#{key}"
    end
    .join("\n").html_safe
  end

end
