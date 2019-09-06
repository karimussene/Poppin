class CuisinesController < ApplicationController
  def index
    @cuisines = Cuisine.with_photo

  end
end
