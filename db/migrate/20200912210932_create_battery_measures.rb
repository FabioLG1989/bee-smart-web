class CreateBatteryMeasures < ActiveRecord::Migration[6.0]
  def change
    create_table :battery_measures do |t|
      t.decimal :voltage
      t.datetime :measured_at
      t.references :battery, null: true, foreign_key: true

      t.timestamps
    end
  end
end
