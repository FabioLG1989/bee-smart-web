class TemperatureGrid < ApplicationRecord
  belongs_to :hive, optional: true
  has_many :temperature_sensors, dependent: :destroy
  has_many :temperature_measures, through: :temperature_sensors
  validates :graph_points, presence: true, numericality: true

  def last_temperature_measure_date
    temperature_measures.last&.measured_at
  end

  def temperature_sensors_sorted
    temperature_sensors.order('uuid ASC')
  end

  def working_positions
    result = []
    temperature_sensors_sorted.each do |sensor|
      if sensor.measure_from_date(last_temperature_measure_date)
        result.append(true)
      else
        result.append(false)
      end
    end
    result
  end

  def last_temperature_measure
    average_from_date(last_temperature_measure_date)
  end

  def average_from_date(date)
    temperature_sensors_sorted.map { |ts| ts.measure_from_date(date) }
  end

  def graph_data
    result = []
    temperature_sensors_sorted.each { |ts| result.append(ts.graph_data) }
    result
  end

  def average_graph_data
    return nil if temperature_measures.empty?
    temperature_measures.where.not(temperature: nil).group(:measured_at).order(measured_at: :desc).limit(graph_points).average(:temperature)
  end

  def csv_collection
    result = []
    temperature_sensors_sorted.each { |ts| result.append(ts.csv_collection) }
    result.flatten
  end
end
