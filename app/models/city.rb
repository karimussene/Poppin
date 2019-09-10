class City < ApplicationRecord
  has_many :restaurants

  validates :name, presence: true
  # validates :photo, presence: true

  def av_attendance(season)
    attendance = 0
    season.each do |month_name|
      attendance += Trend.where("month like ?", "#{month_name}%").sum(:scaled_attendance)
    end
    average_performance = attendance / restaurants.count
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
