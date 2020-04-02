class CreateHives < ActiveRecord::Migration[6.0]
  def change
    create_table :hives do |t|
      t.string :uuid
      t.string :description
      t.references :apiary, null: true, foreign_key: true

      t.timestamps
    end
  end
end
