class AddSeasonAndCityToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :season, :string, array: true, default: []
    add_column :matches, :city, :string
  end
end
