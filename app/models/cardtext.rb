# frozen_string_literal: true

class Cardtext < ApplicationRecord
  has_many :email_texts, dependent: :restrict_with_error
  has_many :emails, through: :email_texts
  belongs_to :holiday

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE


end
