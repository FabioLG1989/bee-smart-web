class AddIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :hives, :uuid
    add_index :apiaries, :uuid
    add_index :scale_measures, :measured_at
    add_index :temperature_measures, :measured_at
  end
end
