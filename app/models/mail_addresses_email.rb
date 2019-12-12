# frozen_string_literal: true

class MailAddressEmail < ApplicationRecord
  belongs_to :mail_address
  belongs_to :email
end
