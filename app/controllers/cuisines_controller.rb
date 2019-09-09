class CuisinesController < ApplicationController
  def index

    session[:city] = params[:city]
    session[:start_period] = params[:start_period]
    session[:end_period] = params[:end_period]

    @cuisines = Cuisine.with_photo
    current_user.favorite_cuisines.destroy_all
  end
end
