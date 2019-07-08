# frozen_string_literal: true

class AddAttachmentImageToPostcards < ActiveRecord::Migration[5.2]
  def self.up
    change_table :postcards do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :postcards, :image
  end
end
