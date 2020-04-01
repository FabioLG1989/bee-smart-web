class CreateTemperatureSensors < ActiveRecord::Migration[6.0]
  def change
    create_table :temperature_sensors do |t|
      t.integer :position
      t.string :uuid
      t.references :temperature_grid, null: true, foreign_key: true

      t.timestamps
    end
  end
end
