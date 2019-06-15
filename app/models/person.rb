class Person < ApplicationRecord
  has_many :companies_people, dependent: :restrict_with_error
  has_many :companies, through: :companies_people

  scope :selectmonth, ->(m) { where("birthday.month = ?", m) } #  self.birthday.month
  scope :selectid, ->(id) { where(id: id) }


  def birthday_form
    self.birthday.nil? ? "dd-mm-yyyy" : self.birthday.strftime("%d-%m-%Y")
  end

  def birthday_index
     self.birthday.nil? ? "" : self.birthday.strftime("%d-%m-%Y")
  end

  def dob_month
    self.birthday.month
  end

end
