class CreateFavoriteCuisines < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_cuisines do |t|
      t.references :cuisine
      t.references :user

      t.timestamps
    end
  end
end
