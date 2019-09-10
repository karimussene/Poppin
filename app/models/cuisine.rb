class Cuisine < ApplicationRecord
  has_many :restaurant_cuisines, dependent: :destroy
  has_many :restaurants, through: :restaurant_cuisines, dependent: :destroy

  has_many :favorite_cuisines
  has_many :trends, dependent: :destroy
  # validates :name, presence: true
  # validates :photo, presence: true

  def self.with_photo
    Cuisine.all.where.not(photo: nil).order(:name)
  end
  def attendance(city)
    trends.where(city: city).sum(:moving_average) # to be changed
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

  def trend_data
    trends.order(:date).map { |trend| [trend.date, trend.moving_average.to_i] }
  end
end
