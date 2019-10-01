# frozen_string_literal: true

class EmailText < ApplicationRecord
  belongs_to :cardtext
  belongs_to :email

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
