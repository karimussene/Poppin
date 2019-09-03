class Trend < ApplicationRecord
  belongs_to :city
  belongs_to :cuisines

  validate :location, presence: true
  validate :cuisine_trend, presence: true
  validate :month, presence: true
  validate :value, presence: true
  validate :city, presence: true
  validate :cuisines, presence: true
end
