class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def create
    @cuisine = Cuisine.find(params[:cuisine_id])

    current_user.matches.where(cuisine: @cuisine).first_or_create do |match|
      match.city = params[:city],
      match.season = params[:season]
    end
  end

  def destroy
    if (params[:cuisine_id])
      @cuisine = Cuisine.find(params[:cuisine_id])
      @match = current_user.matches.find_by(cuisine: @cuisine)
    else
      @match = current_user.matches.find(params[:id])
    end

    @match.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to matches_path }
    end
  end
end
