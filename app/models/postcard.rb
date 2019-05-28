class Postcard < ApplicationRecord
  has_many :email_cards, dependent: :restrict_with_exception
  has_many :emails, through: :email_cards
end
