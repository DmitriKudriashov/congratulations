# frozen_string_literal: true

class EmailCard < ApplicationRecord
  belongs_to :postcard
  belongs_to :email

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
