class CreateScaleMeasures < ActiveRecord::Migration[6.0]
  def change
    create_table :scale_measures do |t|
      t.integer :raw
      t.decimal :weight
      t.datetime :measured_at
      t.references :scale, null: true, foreign_key: true

      t.timestamps
    end
  end
end
