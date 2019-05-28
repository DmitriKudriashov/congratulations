class MailAddress < ApplicationRecord
  belongs_to :companies_person
  has_many :emails



end
