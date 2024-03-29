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

  def av_attendance(_city, season)
    # get the scaled attendance for the months that match the input
    # if end_month lower than start_month, then iterate year by one
    attendance = 0
    season.each do |month_name|
      attendance += trends.where("month like ?", "#{month_name}%").sum(:scaled_attendance)
    end
    if restaurants.count == 0
      average_attendance = 0
    else
      average_attendance = attendance / restaurants.count
    end
    return average_attendance
  end

  def av_rating
    if restaurants.count != 0
      (restaurants.sum(:rating)/restaurants.count.to_f).round(2)
    end
  end

  def av_price_range
    if restaurants.count != 0
      (restaurants.sum(:price_range)/restaurants.count.to_f).round(0)
    end
  end

  def no_restaurants
    restaurants.count
  end

  def trend_data
    query = 'date in '
    trends.order(:date).map { |trend| [trend.date, trend.scaled_attendance.to_i] }.select do |trend|
      ["2017", "2018", "2019"].any? do |year|
        trend[0].first(4).include?(year)
      end
    end
  end
end
