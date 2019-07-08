# frozen_string_literal: true

class Type < ApplicationRecord
  has_many :holidays, dependent: :restrict_with_error
end
