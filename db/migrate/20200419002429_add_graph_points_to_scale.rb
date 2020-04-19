class AddGraphPointsToScale < ActiveRecord::Migration[6.0]
  def change
    add_column :scales, :graph_points, :integer, default: 1000
  end
end
