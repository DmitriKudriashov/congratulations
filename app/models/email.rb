class Email < ApplicationRecord
  has_many :email_cards, dependent: :restrict_with_error
  has_many :postcards, through: :email_cards

  has_many :email_texts, dependent: :restrict_with_error
  has_many :cardtexts, through: :email_texts

  belongs_to :mail_address
  belongs_to :holiday

  def greetings_text
    self.cardtexts.first.present? ? self.cardtexts.first.text : "Text not avalable !"
  end
end
