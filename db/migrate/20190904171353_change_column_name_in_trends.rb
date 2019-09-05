class ChangeColumnNameInTrends < ActiveRecord::Migration[5.2]
  def change
    rename_column :trends, :cuisines_id, :cuisine_id
  end
end
