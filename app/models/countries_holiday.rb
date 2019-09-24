# frozen_string_literal: true

class CountriesHoliday < ApplicationRecord
  belongs_to :country
  belongs_to :holiday

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

end
