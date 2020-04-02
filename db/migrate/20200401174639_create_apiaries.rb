class CreateApiaries < ActiveRecord::Migration[6.0]
  def change
    create_table :apiaries do |t|
      t.references :user, null: true, foreign_key: true
      t.string :description
      t.string :uuid

      t.timestamps
    end
  end
end
