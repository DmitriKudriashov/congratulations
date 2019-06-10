class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :confirmable
  validates :email, uniqueness: true, presence: true, format: /.+@.+\..+/i

  def admin?
    self.admin
  end
end
