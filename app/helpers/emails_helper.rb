module EmailsHelper
  def birthday_emails(d)
    @birthday_man = People.birthday_men(d)
  end

  def checkit_boolean(checkit)
    checkit.to_i > 0 ? true : false
  end
end