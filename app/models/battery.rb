class Battery < ApplicationRecord
  belongs_to :hive, optional: true
  has_many :battery_measures, dependent: :destroy
  validates :graph_points, presence: true, numericality: true

  def last_battery_measure
    battery_measures.last&.voltage
  end

  def last_battery_measure_date
    battery_measures.last&.measured_at
  end

  def graph_data
    graph_data = {}
    battery_measures.last(graph_points).each do |measure|
      graph_data[measure.measured_at] = measure.voltage if measure.voltage
    end
    graph_data
  end

  def csv_collection
    battery_measures.last(graph_points)
  end
end
