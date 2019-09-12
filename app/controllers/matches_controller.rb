class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def create
    cuisine = Cuisine.find(params[:cuisine_id])

    @match = Match.create(
      user: current_user,
      cuisine: cuisine,
      city: params[:city],
      season: params[:season]
    )

    redirect_to matches_path, notice: "Added #{cuisine.name} to your favorites."
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to matches_path
  end
end
