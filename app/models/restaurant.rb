class Restaurant < ApplicationRecord
  belongs_to :city
  has_many :restaurant_cuisines, dependent: :destroy
  has_many :cuisines, through: :restaurant_cuisines

  # validates :name, presence: true
  # validates :address, presence: true
  # validates :rating, presence: true
  # validates :price_range, presence: true

  # validates :photo
end
