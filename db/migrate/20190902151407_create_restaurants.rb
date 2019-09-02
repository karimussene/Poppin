class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :address
      t.integer :attendance
      t.integer :capacity
      t.integer :rating
      t.integer :price_range
      t.string :photo
      t.references :city
      t.references :cuisine

      t.timestamps
    end
  end
end
