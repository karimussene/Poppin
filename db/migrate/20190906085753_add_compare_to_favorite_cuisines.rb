class AddCompareToFavoriteCuisines < ActiveRecord::Migration[5.2]
  def change
    add_column :favorite_cuisines, :compare, :boolean, default: false
  end
end
