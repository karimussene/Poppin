class TrendsController < ApplicationController
  before_action :fetch_city
  def results

    @season = selected_season(session[:start_period], session[:end_period])

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

  # def selected_season(start_period, end_period)
  #   start_date = Date.parse(start_period)
  #   if Date.parse(end_period) < start_date
  #     end_date = Date.parse(end_period).next_year
  #   else
  #     end_date = Date.parse(end_period)
  #   end
  #   season_array = (start_date..end_date)
  #   season_months = []
  #   season_array.each do |date|
  #     season_months << Date::ABBR_MONTHNAMES[date.month]
  #   end
  #   season_months.uniq { |month| month }
  # end

  def selected_season(start_period, end_period)
    start = start_period.to_i
    finish = end_period.to_i
    if finish < start
      season_months = (start..12).to_set.merge(1..finish)
    else
      season_months = (start..finish)
    end
    season_months.map do |month_number|
      Date::ABBR_MONTHNAMES[month_number]
    end
  end
end
