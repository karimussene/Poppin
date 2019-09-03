class CreateTrends < ActiveRecord::Migration[5.2]
  def change
    create_table :trends do |t|
      t.string :location
      t.string :cuisine_trend
      t.string :month
      t.string :value
      t.references :city, foreign_key: true
      t.references :cuisines, foreign_key: true

      t.timestamps
    end
  end
end
