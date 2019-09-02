class City < ApplicationRecord
  has_many :restaurants

  validates :name, prensence: true
  validates :photo, prensence: true
end
