class TrendsController < ApplicationController
  before_action :fetch_city
  def results

    if params[:query].present?
      @favoritecuisines = []
      filter = params[:query].to_sym
      @userfavorite = current_user.favorite_cuisines
                                      .map(&:cuisine)
                                      .sort_by(&filter)
                                      # sort_by { |c| c.attendance(@city))}.reverse
      @userfavorite.each do |fav|
        @favoritecuisines << current_user.favorite_cuisines.where(cuisine_id: fav.id).first
      end
      @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }

    elsif params[:metrics].present?
      @favoritecuisines = []
      filter = params[:metrics].to_sym
      @userfavorite = current_user.favorite_cuisines
                                      .map(&:cuisine)
                                      .sort_by(&filter)
                                      # sort_by { |c| c.attendance(@city))}.reverse
      @userfavorite.each do |fav|
        @favoritecuisines << current_user.favorite_cuisines.where(cuisine_id: fav.id).first
      end
      @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }
      @favoritecuisines.reverse!

    elsif params[:attendance].present?
      @favoritecuisines = []
      filter = params[:attendance].to_sym
      @userfavorite = current_user.favorite_cuisines
                                      .map(&:cuisine)
                                      .sort_by { |c| c.attendance(@city) }.reverse
      @userfavorite.each do |fav|
        @favoritecuisines << current_user.favorite_cuisines.where(cuisine_id: fav.id).first
      end
      @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }
      # @favoritecuisines.reverse!

    else
      @favoritecuisines = current_user.favorite_cuisines
      @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      @comparisoncuisines = @favoritecuisines.where(compare: true)
    end
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

  def graph

    @favoritecuisines = current_user.favorite_cuisines.map(&:cuisine)
    # selected_cuisines = Cuisine.where(id: [56, 60, 134])
    # @cuisines_map = selected_cuisines.map do |cuisine|
    @cuisines_map = @favoritecuisines.map do |cuisine|
      {
        name: cuisine.name,
        data: cuisine.trend_data
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
