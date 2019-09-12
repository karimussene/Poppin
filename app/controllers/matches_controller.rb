class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def create
    @cuisine = Cuisine.find(params[:cuisine_id])

    Match.create(
      user: current_user,
      cuisine: @cuisine,
      city: params[:city],
      season: params[:season]
    )
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
