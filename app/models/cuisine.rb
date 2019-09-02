class Cuisine < ApplicationRecord
  has_many :restaurants
  has_many :favorite_cuisines

  validates :name, prensence: true
  validates :photo, prensence: true
end
