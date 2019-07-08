# frozen_string_literal: true

module EmailsHelper
  def birthday_emails(d)
    @birthday_man = Person.birthday_men(d)
  end

  def checkit_boolean(checkit)
    checkit.to_i.positive?
  end

  def set_email_cards(id)
    @email_cards = EmailCard.where(email_id: id)
  end
end
