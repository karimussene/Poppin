class AddMovingAverageToTrends < ActiveRecord::Migration[5.2]
  def change
    add_column :trends, :moving_average, :float
    add_column :trends, :scaled_attendance, :float
  end
end
