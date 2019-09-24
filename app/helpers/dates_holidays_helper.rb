# frozen_string_literal: true

module DatesHolidaysHelper
  def list_dates_holiday; end

  def list_birthdays(day, month)
    list = ''
    Person.birthdays_to_date(day, month).map do |person|
      list += person.present? ? "#{modify_name(person.name)} / \n" : ''
    end
    list
  end

  def list_holidays(day, month)
    list = holidays_all(day, month, 0)
    list += holidays_all(day, month, Date.today.year)
  end

  def holidays_all(day, month, year)
    list = ''
    DatesHoliday.holidays_to_date(day, month, year).map do |dh|
      list += list_element(dh)
    end
    list
  end

  def list_element(dates_holiday)
    name_holiday = dates_holiday.holiday.name
    return '' if name_holiday.eql?('Birthday')

    dates_holiday.present? ? "#{name_holiday} / \n" : ''
  end

  def birthday_today(n)
    date = Date.today + n
    day = date.day
    month = date.month
    list = list_birthdays(day, month)
    list.empty? ? '-' : list
  end

  def holidays_today(n)
    date = Date.today + n
    day = date.day
    month = date.month
    list = list_holidays(day, month)
    list.empty? ? '-' : list
  end

  def tag_birthday(n)
    list = birthday_today(n)
    if list.eql?('-')
      tag.a(list.to_s, class: 'empty')
    else
      opt = n.eql?(0) ? { class: 'today', size: :auto } : { class: 'near_today', size: :auto }
      # list_links(list)
      tag.text(list.to_s, opt)
    end
  end

  def tag_holiday(n)
    list = holidays_today(n)
    if list.eql?('-')
      tag.a(list.to_s, class: 'empty')
    else
      opt = n.eql?(0) ? { class: 'today', size: :auto } : { class: 'near_today', size: :auto }
      tag.text(list.to_s, opt)
    end
  end

  def people_list(dates_holiday)
    people = dates_holiday.list_people
    text_area_tag(:text, people, size: :auto) if people.present?
    # tag.text( people, size: :auto) if people.present?
  end

  def view_holidays(log_sign)
    if log_sign.to_i.eql?(0)
      link_to 'View Left out holidays', dates_holidays_path, logsign: log_sign.to_i
    else
      link_to 'View All holidays', controller: 'dates_holidays', id: 'index', class: 'dates_holidays',
                                   method: :gets, logsign: log_sign.to_i
    end
  end
  def full_calendar
    view_holidays(1)
  end
  def left_out_holidays
     view_holidays(0)
  end

end
