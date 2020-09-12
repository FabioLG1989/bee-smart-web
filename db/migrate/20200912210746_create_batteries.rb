class CreateBatteries < ActiveRecord::Migration[6.0]
  def change
    create_table :batteries do |t|
      t.references :hive, null: true, foreign_key: true
      t.integer :graph_points,  default: 1000

      t.timestamps
    end
  end
end
