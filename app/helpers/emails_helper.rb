# frozen_string_literal: true

module EmailsHelper

  def checkit_boolean(checkit)
    checkit.to_i.positive?
  end

  # def set_email_cards(id)
  #   @email_cards = EmailCard.where(email_id: id)
  # end

  def delete_all_unchecked
    # byebug
    link_to 'Destroy All Unchecking !', controller: 'emails', id: 'destroy_unchecked', method: :post
  end

  def list_companies(email)
    i = 0
    list = ''
    array_companies = []
    email.companies_emails.each {|companies_email| array_companies << companies_email.company.name }
    array_companies.sort!
    array_companies.each {|x| i += 1; list += " #{i}. #{x} \n" }
    list
  end
end
