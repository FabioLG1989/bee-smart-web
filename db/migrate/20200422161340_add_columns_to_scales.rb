class AddColumnsToScales < ActiveRecord::Migration[6.0]
  def change
    add_column :scales, :next_tare, :boolean, default: false
    add_column :scales, :next_slope, :decimal, default: nil, null: true
  end
end
