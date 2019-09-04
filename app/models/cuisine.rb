class Cuisine < ApplicationRecord
  has_many :restaurant_cuisines, dependent: :destroy
  has_many :restaurants, through: :restaurant_cuisines

  has_many :favorite_cuisines

  validates :name, presence: true
  # validates :photo#, presence: true
end
