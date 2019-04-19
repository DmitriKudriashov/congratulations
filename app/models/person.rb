class Person < ApplicationRecord
  has_many :companies_people, dependent: :destroy
end
