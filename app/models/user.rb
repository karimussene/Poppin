class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorite_cuisines
  has_many :cuisines, through: :favorite_cuisines

  # validates :name, prensence: true
  # validates :email, prensence: true
end
