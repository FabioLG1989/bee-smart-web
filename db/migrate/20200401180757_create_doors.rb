class CreateDoors < ActiveRecord::Migration[6.0]
  def change
    create_table :doors do |t|
      t.integer :status
      t.integer :last_command
      t.references :hive, null: true, foreign_key: true

      t.timestamps
    end
  end
end
