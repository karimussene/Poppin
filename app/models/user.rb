class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorite_cuisines
  has_many :cuisines, through: :favorite_cuisines
  has_many :matches
  has_many :matched_cuisines, through: :matches, source: :cuisine, class_name: 'Cuisine'

  def matched?(cuisine)
    matched_cuisines.pluck(:id).include?(cuisine.id)
  end
end
