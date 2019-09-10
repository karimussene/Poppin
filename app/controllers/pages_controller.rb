class PagesController < ApplicationController
  skip_before_action :authenticate_user! #, only: [:home]

  def home
  end

  # def test
  #   selected_cuisines = Cuisine.where(id: [56, 60, 134])

  #   @cuisines_map = selected_cuisines.map do |cuisine|
  #   # @cuisines_map = @favoritecuisines.map do |cuisine|
  #     {
  #       name: cuisine.name,
  #       data: cuisine.trend_data
  #     }
  #   end
  # end
end
