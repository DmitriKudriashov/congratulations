# frozen_string_literal: true

class CountriesHoliday < ApplicationRecord
  belongs_to :country
  belongs_to :holiday

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
