class Restaurant < ApplicationRecord
  belongs_to :city
  belongs_to :cuisine

  validates :name, prensence: true
  validates :address, prensence: true
  validates :attendance, prensence: true
  validates :capacity, prensence: true
  validates :rating, prensence: true
  validates :price_range, prensence: true
  validates :photo, prensence: true
  validates :city, prensence: true
  validates :cuisine, prensence: true
end
