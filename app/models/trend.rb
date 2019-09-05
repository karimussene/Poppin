class Trend < ApplicationRecord
  belongs_to :city
  belongs_to :cuisine

  # # validates :location, presence: true
  # # validates :cuisine_trend, presence: true
  # validates :month, presence: true
  # validates :value, presence: true
  # validates :city, presence: true
  # validates :cuisine, presence: true
end
