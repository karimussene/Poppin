class Trend < ApplicationRecord
  belongs_to :city
  belongs_to :cuisine #, dependent: :destroy

  # # validates :location, presence: true
  # # validates :cuisine_trend, presence: true
  # validates :month, presence: true
  # validates :value, presence: true
  # validates :city, presence: true
  # validates :cuisine, presence: true

  def self.attendance(city)
    Trend.where(city_id: 1).sum(:moving_average).round(0) # to be changed
  end
end
