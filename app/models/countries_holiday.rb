class CountriesHoliday < ApplicationRecord
  belongs_to :country
  belongs_to :holiday
end
