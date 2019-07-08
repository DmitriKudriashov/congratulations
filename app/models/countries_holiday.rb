# frozen_string_literal: true

class CountriesHoliday < ApplicationRecord
  belongs_to :country
  belongs_to :holiday
end
