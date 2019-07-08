# frozen_string_literal: true

class Cardtext < ApplicationRecord
  has_many :email_texts, dependent: :restrict_with_error
  has_many :emails, through: :email_texts
  belongs_to :holiday
end
