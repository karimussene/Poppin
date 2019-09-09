class TrendsController < ApplicationController
  before_action :fetch_city
  def results
    @favoritecuisines = current_user.favorite_cuisines
    @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
    @comparisoncuisines = @favoritecuisines.where(compare: true)
  end

  def map
    @cuisine = Cuisine.find(params[:cuisine_id])
    @restaurants = @cuisine.restaurants.where(city: @city)
    @geojson = build_geojson
    @markers = @restaurants.map do |r|
      {
        lat: r.latitude,
        lng: r.longitude
      }
    end
  end

  private

  def fetch_city
    @city = City.where(name: "Sydney").first
  end

  def build_geojson
    {
      type: "FeatureCollection",
      features: @restaurants.map(&:to_feature)
    }
  end
end
