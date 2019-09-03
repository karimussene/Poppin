class Restaurant < ApplicationRecord
  belongs_to :city
  belongs_to :cuisine

  validates :name, presence: true
  validates :address, presence: true
  validates :attendance, presence: true
  validates :capacity, presence: true
  validates :rating, presence: true
  validates :price_range, presence: true
  # validates :photo
  validates :city, presence: true
  validates :cuisine, presence: true
end
