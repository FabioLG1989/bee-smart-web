class AddNameToApiariesAndHives < ActiveRecord::Migration[6.0]
  def change
    add_column :hives, :name, :string, null: true
    add_column :apiaries, :name, :string, null: true
  end
end
