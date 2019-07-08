# frozen_string_literal: true

class EmailCard < ApplicationRecord
  belongs_to :postcard
  belongs_to :email
end
