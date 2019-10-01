# frozen_string_literal: true

class Cardtext < ApplicationRecord
  has_many :email_texts, dependent: :restrict_with_error
  has_many :emails, through: :email_texts
  belongs_to :holiday

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
