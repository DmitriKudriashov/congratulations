# frozen_string_literal: true

class MailAddress < ApplicationRecord
  belongs_to :companies_person
  has_many :emails, dependent: :restrict_with_error

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
