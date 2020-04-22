class TemperatureSensor < ApplicationRecord
  belongs_to :temperature_grid, optional: true
  has_many :temperature_measures, dependent: :destroy
  delegate :temperature_sensors_sorted, :graph_points, to: :temperature_grid, prefix: true, allow_nil: true

  validates :uuid, uniqueness: true, presence: true

  def index
    temperature_grid_temperature_sensors_sorted.find_index(self)
  end

  def measure_from_date(date)
    temperature_measures.valid.where(measured_at: date).first&.temperature
  end

  def graph_data
    result = {}
    temperature_measures.last(temperature_grid_graph_points).each do |measure|
      result[measure.measured_at] = measure.temperature if measure.temperature
    end
    result
  end

  def csv_collection
    temperature_measures.last(temperature_grid_graph_points)
  end
end
