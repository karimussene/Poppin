class TrendsController < ApplicationController
  def results
    @favoritecuisines = current_user.favorite_cuisines
    @unselectedcuisines = Cuisine.with_photo.where.not(id: @favoritecuisines.pluck(:cuisine_id))
    @comparisoncuisines = @favoritecuisines.where(compare: true)
  end

end
