class AddGraphPointsToTemperatureGrids < ActiveRecord::Migration[6.0]
  def change
    add_column :temperature_grids, :graph_points, :integer, default: 1000
  end
end
