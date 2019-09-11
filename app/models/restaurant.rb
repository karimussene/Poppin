class Restaurant < ApplicationRecord
  belongs_to :city
  has_many :restaurant_cuisines, dependent: :destroy
  has_many :cuisines, through: :restaurant_cuisines

  def coordinates
    [longitude, latitude]
  end

  def to_feature
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": coordinates
      },
      "properties": {
        "restaurant_id": id,
        "name": name,
        "attendance": attendance
        # "info_window": ApplicationController.new.render_to_string(
        #   partial: "restaurants/infowindow",
        #   locals: { restaurant: self }
        # )
      }
    }
  end

  # validates :name, presence: true
  # validates :address, presence: true
  # validates :rating, presence: true
  # validates :price_range, presence: true

  # validates :photo
end
