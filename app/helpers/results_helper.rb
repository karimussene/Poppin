module ResultsHelper
  def top_cuisine_link_to(cuisine, favorites, options = {})
    fav_cusine = favorites.find { |fav| fav.cuisine.id == cuisine.id }

    if fav_cusine
      link_to(favorite_cuisine_path(fav_cusine), options.merge(method: :delete)) do
        yield
      end
    else
      link_to(add_favorite_cuisines_path(cuisine_id: cuisine.id), options) do
        favorites.include?(cuisine)
        yield
      end
    end
  end
end
