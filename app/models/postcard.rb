# frozen_string_literal: true

class Postcard < ApplicationRecord
  # :rails_root/public/system/:class/:attachment/:id_partition/:style/:filename
  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>', small: '50x50' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\z}

  validates :image, attachment_presence: true
  validates_with AttachmentPresenceValidator, attributes: :image
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 200.megabytes

  has_many :email_cards, dependent: :restrict_with_error
  has_many :emails, through: :email_cards

  belongs_to :holiday
  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
