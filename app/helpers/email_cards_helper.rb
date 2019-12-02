# frozen_string_literal: true

module EmailCardsHelper
  def postcards_for_select(holiday_id, email_card)
    Postcard.where(holiday_id: holiday_id).left_outer_joins(email_cards: :email).where('email_cards.id is null or email_cards.id = ?', email_card).uniq
  end
end
