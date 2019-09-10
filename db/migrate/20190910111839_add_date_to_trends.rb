class AddDateToTrends < ActiveRecord::Migration[5.2]
  def change
    add_column :trends, :date, :string
  end
end
