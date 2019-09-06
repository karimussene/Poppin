class CuisinesController < ApplicationController
  def index
    @cuisines = Cuisine.with_photo
    current_user.favorite_cuisines.destroy_all
  end
end
