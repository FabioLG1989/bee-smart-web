class CreateTemperatureGrids < ActiveRecord::Migration[6.0]
  def change
    create_table :temperature_grids do |t|
      t.references :hive, null: true, foreign_key: true

      t.timestamps
    end
  end
end
