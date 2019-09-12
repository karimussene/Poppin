class FavoriteCuisinesController < ApplicationController
  def create
    current_user.favorite_cuisines.destroy_all
    user_choices = params[:user][:cuisine_ids]
    user_choices.each {|cuisine_id| FavoriteCuisine.create(user: current_user, cuisine_id: cuisine_id) }
    redirect_to results_path
  end

  def add
    FavoriteCuisine.create(user: current_user, cuisine_id: params[:cuisine_id])
    redirect_to results_path
  end

  def destroy
    FavoriteCuisine.find(params[:id]).destroy # id in the url in that case. Otherwise coming from a views and could be from params
    redirect_to results_path
  end
  def compare
    fc = FavoriteCuisine.find(params[:favorite_cuisine_id])
    fc.compare = true
    fc.save
    redirect_to results_path
  end
  def uncompare
    fc = FavoriteCuisine.find(params[:favorite_cuisine_id])
    fc.compare = false
    fc.save
    redirect_to results_path
  end

end
