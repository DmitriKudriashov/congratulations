# frozen_string_literal: true

class MailAddress < ApplicationRecord
  belongs_to :companies_person
  has_many :emails, dependent: :restrict_with_error

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

end
