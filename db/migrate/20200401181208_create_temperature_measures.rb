class CreateTemperatureMeasures < ActiveRecord::Migration[6.0]
  def change
    create_table :temperature_measures do |t|
      t.decimal :temperature
      t.datetime :measured_at
      t.references :temperature_sensor, null: true, foreign_key: true

      t.timestamps
    end
  end
end
