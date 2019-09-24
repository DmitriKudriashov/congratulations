# frozen_string_literal: true

class Type < ApplicationRecord
  has_many :holidays, dependent: :restrict_with_error

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

end
