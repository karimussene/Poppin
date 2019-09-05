class CuisineController < ApplicationController
  def index
    @cuisines = Cuisine.all
  end
end
