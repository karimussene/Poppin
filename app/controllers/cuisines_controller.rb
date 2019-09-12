class CuisinesController < ApplicationController
  def index
    session[:city] = params[:city]
    session[:start_period] = params[:start_period]
    session[:end_period] = params[:end_period]

    update_ranking_in_cuisines

    @cuisines = Cuisine.with_photo
    current_user.favorite_cuisines.destroy_all
  end

  private

  def update_ranking_in_cuisines
    cuisines = Cuisine.all.sort_by do |cuisine|
      cuisine.av_attendance(params[:city], selected_season(params[:start_period], params[:end_period]))
    end.reverse

    cuisines.each.with_index do |cuisine, index|
      cuisine.update_column(:ranking, index + 1)
    end
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
end
