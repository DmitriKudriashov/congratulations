# frozen_string_literal: true

class EmailText < ApplicationRecord
  belongs_to :cardtext
  belongs_to :email
end
