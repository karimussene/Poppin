class Cuisine < ApplicationRecord
  has_many :restaurants, through: :restaurant_cuisines

  has_many :favorite_cuisines
  belongs_to :trend
  validates :name, presence: true
  # validates :photo#, presence: true
end
