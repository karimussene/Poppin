class FavoriteCuisinesController < ApplicationController
  def create
    current_user.favorite_cuisines.destroy_all
    user_choices = params[:user][:cuisine_ids]
    user_choices.each {|cuisine_id| FavoriteCuisine.create(user: current_user, cuisine_id: cuisine_id) }
    redirect_to results_path
  end
end
