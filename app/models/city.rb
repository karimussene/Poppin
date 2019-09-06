class City < ApplicationRecord
  has_many :restaurants

  validates :name, presence: true
  # validates :photo, presence: true

  def attendance
    Trends.where(city_id: 1).sum(:moving_average) # to be changed
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
