class AddRankingToCuisines < ActiveRecord::Migration[5.2]
  def change
    add_column :cuisines, :ranking, :integer
  end
end
