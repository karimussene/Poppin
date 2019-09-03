class Restaurant < ApplicationRecord
  belongs_to :city
  has_many :cuisines, through: :restaurant_cuisines

  validates :name, presence: true
  validates :address, presence: true
  validates :attendance, presence: true
  validates :capacity, presence: true
  validates :rating, presence: true
  validates :price_range, presence: true
  validates :photo, presence: true
  validates :city, presence: true
  validates :cuisine, presence: true
end
