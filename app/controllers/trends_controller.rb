class TrendsController < ApplicationController
  before_action :fetch_city
  # before_action :attendance_array, only: [:map]
  before_action :rating_array, only: [:map]
  before_action :price_array, only: [:map]
  before_action :competitors_array, only: [:map]
  before_action :trend_indication, only: [:map]
  before_action :threshold, only: [:map]
  def results

    @season = selected_season(session[:start_period], session[:end_period])

    if params[:query].present?
      #  sort by name
      @favoritecuisines = []
      filter = params[:query].to_sym
      @userfavorite = current_user.favorite_cuisines
                                      .map(&:cuisine) # map(|cuisine| cuisine)
                                      .sort_by(&filter)
                                      # sort_by { |c| c.attendance(@city))}.reverse
      @userfavorite.each do |fav|
        @favoritecuisines << current_user.favorite_cuisines.where(cuisine_id: fav.id).first
      end
      # @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      # @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }

    elsif params[:metrics].present?
      # sort by all metrics which are numbers exept attendance
      @favoritecuisines = []
      filter = params[:metrics].to_sym
      @userfavorite = current_user.favorite_cuisines
                                      .map(&:cuisine)
                                      .sort_by(&filter)
                                      # sort_by { |c| c.attendance(@city))}.reverse
      @userfavorite.each do |fav|
        @favoritecuisines << current_user.favorite_cuisines.where(cuisine_id: fav.id).first
      end
      # @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      # @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }
      @favoritecuisines.reverse!

    else params[:attendance].present?
      #  sort by attendance
      @favoritecuisines = []
      @userfavorite = current_user.favorite_cuisines
                                      .map(&:cuisine)
                                      .sort_by { |c| c.av_attendance(@city,@season) }.reverse
      @userfavorite.each do |fav|
        @favoritecuisines << current_user.favorite_cuisines.where(cuisine_id: fav.id).first
      end
      # @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
      # @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }

    # else
    #   @favoritecuisines = current_user.favorite_cuisines
    end
      @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id)).sort_by { |c| c.av_attendance(@city, @season) }.reverse
      @comparisoncuisines = @favoritecuisines.select { |fav| fav.compare == true }
      @cuisines = Cuisine.all.sort_by { |c| c.av_attendance(@city, @season) }.reverse
  end

  def map
    @cuisine = Cuisine.find(params[:cuisine_id])
    @season = params[:season]
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
    # @cuisines_map = Cuisine.where(id: params[:graph_cuisines].split("-")).map do |cuisine|
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

  def attendance_array
    @season = params[:season]
    @cuisines_sorted_by_attendance = Cuisine.all.sort_by { |c| c.av_attendance(@city, @season) }.reverse
    @cuisine_attendance_array = Cuisine.all.map { |c| c.av_attendance(@city, @season) }.reverse
  end

  def rating_array
    @cuisines_sorted_by_rating = Cuisine.all.sort_by { |c| c.av_rating }.reverse
    @cuisine_rating_array = Cuisine.all.map { |c| c.av_rating }.reverse
  end
  def competitors_array
    @cuisines_sorted_by_no_competitors = Cuisine.all.sort_by { |c| c.no_restaurants }
    @cuisine_no_competitors_array = Cuisine.all.map { |c| c.no_restaurants }
  end
  def price_array
    @cuisines_sorted_by_rating = Cuisine.all.sort_by { |c| c.av_price_range }
    @cuisine_competitors_array = Cuisine.all.map { |c| c.av_price_range }
  end
  def trend_indication
    @av_trend_current_year = Trend.all.where(cuisine_id: params[:cuisine_id]).where("month like ?","%#{Time.now.year}%").sum(:scaled_attendance)/9
    @av_trend_previous_year = Trend.all.where(cuisine_id: params[:cuisine_id]).where("month like ?","%#{Time.now.year - 1}%").sum(:scaled_attendance)/12
  end
  def threshold
    @high_percentile_index = Cuisine.all.count/4
    @low_percentile_index = Cuisine.all.count/4*2
  end
end
