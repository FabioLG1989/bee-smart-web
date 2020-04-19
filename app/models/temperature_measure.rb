class TemperatureMeasure < ApplicationRecord
  belongs_to :temperature_sensor, optional: true
  delegate :temperature_grid, to: :temperature_sensor, allow_nil: true
  delegate :hive, to: :temperature_grid, allow_nil: true
  delegate :id, to: :hive, allow_nil: true, prefix: true
  delegate :apiary, to: :hive, allow_nil: true
  delegate :id, to: :apiary, allow_nil: true, prefix: true
  delegate :index, to: :temperature_sensor, prefix: true, allow_nil: true

  scope :valid, -> { where.not(temperature: -1) }

  def self.to_csv(ids)
    attributes = %w{ apiary_id hive_id temperature_sensor_index temperature measured_at }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      TemperatureMeasure.where(id: ids).each do |measure|
        csv << attributes.map { |attr| measure.send(attr) }
      end
    end
  end
end
