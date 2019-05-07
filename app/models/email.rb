class Email < ApplicationRecord
  has_many :email_cards
  has_many :email_texts
  belongs_to :mail_address
end
