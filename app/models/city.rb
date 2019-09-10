class City < ApplicationRecord
  has_many :restaurants

  validates :name, presence: true
  # validates :photo, presence: true

  def attendance
    Trend.where(city_id: 1).sum(:scaled_attendance)# to be changed
  end
  def av_rating
    if restaurants.count != 0
      restaurants.sum(:rating)/restaurants.count.round(2)
    end
  end
  def av_price_range
    if restaurants.count != 0
      restaurants.sum(:price_range)/restaurants.count.to_f.round(0)
    end
  end
  def no_restaurants
    restaurants.count
  end
end
