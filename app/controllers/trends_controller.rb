class TrendsController < ApplicationController
  before_action :fetch_city
  before_action :threshold
  before_action :attendance_array, only: [:map]
  before_action :rating_array, only: [:map]
  before_action :price_array, only: [:map]
  before_action :competitors_array, only: [:map]
  before_action :trend_indication, only: [:map]
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
      # @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id)).sort_by { |c| c.av_attendance(@city, @season) }.reverse
      @unselectedcuisines = Cuisine.with_photo.sort_by { |c| c.av_attendance(@city, @season) }.reverse
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
    @season = params[:season]
    @cuisines = current_user.favorite_cuisines.map(&:cuisine).sort_by { |c| c.av_attendance(@city, @season) }.reverse

    @cuisines_map = @cuisines.map do |cuisine|
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
    @cuisines_sorted_by_attendance = Cuisine.all.sort_by {|c| c.av_attendance(@city, @season) }.reverse
    @cuisine_attendance_array = @cuisines_sorted_by_attendance.map { |c| c.av_attendance(@city, @season) }
    @threshold_attendance_top = @cuisine_attendance_array[@high_percentile_index]
    @threshold_attendance_bottom = @cuisine_attendance_array[@low_percentile_index]
  end

  def rating_array
    @cuisines_sorted_by_attendance = Cuisine.all.sort_by {|c| c.av_attendance(@city, @season) }.reverse
    @cuisine_rating_array = @cuisines_sorted_by_attendance.map { |c| c.av_rating }
    @average_top_rating = @cuisine_rating_array.first(@high_percentile_index).sum/@high_percentile_index
    @average_mid_rating = @cuisine_rating_array[@high_percentile_index..@low_percentile_index].sum/@low_percentile_index
  end
  def competitors_array
    @cuisines_sorted_by_attendance = Cuisine.all.sort_by {|c| c.av_attendance(@city, @season) }.reverse
    @cuisine_no_competitors_array = @cuisines_sorted_by_attendance.map {|c| c.no_restaurants}
    @average_top_competitors = @cuisine_no_competitors_array.first(@high_percentile_index).sum/@high_percentile_index
    @average_mid_competitors = @cuisine_no_competitors_array[@high_percentile_index..@low_percentile_index].sum/@low_percentile_index
  end
  def price_array
    @cuisines_sorted_by_attendance = Cuisine.all.sort_by {|c| c.av_attendance(@city, @season) }.reverse
    @cuisine_price_array = @cuisines_sorted_by_attendance.map { |c| c.av_price_range }
    @average_top_price = @cuisine_price_array.first(@high_percentile_index).sum/@high_percentile_index
    @average_mid_price = @cuisine_price_array[@high_percentile_index..@low_percentile_index].sum/@low_percentile_index
  end
  def trend_indication
    @av_trend_current_year = Trend.all.where(cuisine_id: params[:cuisine_id]).where("month like ?","%#{Time.now.year}%").sum(:scaled_attendance)/9
    @av_trend_previous_year = Trend.all.where(cuisine_id: params[:cuisine_id]).where("month like ?","%#{Time.now.year - 1}%").sum(:scaled_attendance)/12
    if @av_trend_previous_year!=0 && @av_trend_current_year / @av_trend_previous_year > 1.05
      @trend = "increasing ↗️"
    elsif @av_trend_previous_year!=0 && (@av_trend_current_year / @av_trend_previous_year < 1.05 || @av_trend_current_year / @av_trend_previous_year > 0.95)
      @trend = "stable ➡️"
    elsif @av_trend_previous_year!=0 && @av_trend_current_year / @av_trend_previous_year < 0.95
      @trend = "decreasing ↘️"
    else
      @trend = "No trend"
    end
  end
  def threshold
    @high_percentile_index = Cuisine.all.count/3.to_i-1
    @low_percentile_index = Cuisine.all.count/4*3.to_i-1
  end


  def recommendation
    if @cuisines_sorted_by_attendance.first(@high_percentile_index).include? (@cuisine)
      high_end_cuisine
    else
      low_end_cuisine
    end
  end

  def high_end_cuisine
    attendance = @cuisine.av_attendance(@city, @season)
    case attendance
    when attendance / @threshold_attendance_top > 1.25
      @attendance_evaluation = "the attendance for #{@cuisine} is #{((attendance / @threshold_attendance_top)* 100).floor - 100 } higher the the average top ranked restaurant"
    when attendance / @threshold_attendance_top > 1.1
      @attendance_evaluation = "the attendance for #{@cuisine} is #{((attendance / @threshold_attendance_top)* 100).floor - 100 } higher the the average top ranked restaurant"

    end
  end

  def low_end_cuisine
    @results = "results low"
  end

end
