# frozen_string_literal: true

class EmailCard < ApplicationRecord
  belongs_to :postcard
  belongs_to :email

  self.per_page = self.all.count/5
  self.per_page = self.per_page > $PER_PAGE ? self.per_page : $PER_PAGE

end
