class Cardtext < ApplicationRecord
  has_many :email_texts, dependent: :restrict_with_error
end
