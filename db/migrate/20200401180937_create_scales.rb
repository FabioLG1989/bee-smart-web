class CreateScales < ActiveRecord::Migration[6.0]
  def change
    create_table :scales do |t|
      t.integer :tare
      t.decimal :slope
      t.references :hive, null: true, foreign_key: true

      t.timestamps
    end
  end
end
