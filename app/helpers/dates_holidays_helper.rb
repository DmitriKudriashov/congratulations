# frozen_string_literal: true

module DatesHolidaysHelper
  def list_dates_holiday; end

  def list_birthdays(day, month)
    list = ''
    Person.birthdays_to_date(day, month).map do  |person|
      list += person.present? ? "#{person.name} / \n" : ''
    end
    list
  end

  def list_links(list)
    links = []
    list.split('/').each do |person|
      links << "link_to person, person"
    end
  end

  def birthday_today(n)
    date = Date.today + n
    day = date.day
    month = date.month
    list = list_birthdays(day, month)
    list.empty? ? '-' : list
  end

  def tag_birthday(n)
    list = birthday_today(n)
    if list == '-'
      tag.a("#{list}", {class: "empty"})
    else
      opt = n == 0 ? {class: "today", size: :auto} : {class: "near_today", size: :auto}
      # list_links(list)
      tag.text("#{list}", opt )
    end
  end

  def people_list(dates_holiday)
    people = dates_holiday.list_people
    text_area_tag(:text, people, size: :auto) if people.present?
    # tag.text( people, size: :auto) if people.present?
  end

end
