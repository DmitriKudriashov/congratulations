# frozen_string_literal: true

module TypesHelper

  def holidays_of_type(type)
    list = ''
    type.holidays.order(:name).each {|holiday| list += "#{holiday.name} \n"}
    list
  end

end
