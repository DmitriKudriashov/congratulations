# frozen_string_literal: true

class CompaniesHoliday < ApplicationRecord
  belongs_to :company
  belongs_to :holiday

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
