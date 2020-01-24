# frozen_string_literal: true

class Type < ApplicationRecord
  has_many :holidays, dependent: :restrict_with_error
  accepts_nested_attributes_for :holidays #, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  attr_accessor :holidays_attributes

  self.per_page = all.count / 5
  self.per_page = per_page > $PER_PAGE ? per_page : $PER_PAGE
end
