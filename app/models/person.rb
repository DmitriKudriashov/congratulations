class Person < ApplicationRecord
  has_many :companies_people, dependent: :restrict_with_error
  has_many :companies, through: :companies_people

  def birthday_form
    # self.birthday.nil? ? Date.today : self.birthday.strftime("%d-%m-%Y")
    self.birthday.nil? ? "dd-mm-yyyy" : self.birthday.strftime("%d-%m-%Y")
  end

  def birthday_index
     self.birthday.nil? ? "" : self.birthday.strftime("%d-%m-%Y")
  end

end
