class Hive < ApplicationRecord
  belongs_to :apiary, optional: true
  has_one :temperature_grid, dependent: :destroy
  has_one :door, dependent: :destroy
  has_one :scale, dependent: :destroy

  delegate :last_temperature_measure, :last_temperature_measure_date, to: :temperature_grid
  delegate :working_positions, :graph_data, :csv_collection, to: :temperature_grid, prefix: true
  delegate :last_weight_measure, :last_weight_measure_date, to: :scale
  delegate :calibrated, :graph_data, :csv_collection, to: :scale, prefix: true
  delegate :status_to_s, :last_command_to_s, to: :door, prefix: true

  has_many :messages
end
