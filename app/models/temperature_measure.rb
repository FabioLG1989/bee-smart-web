class TemperatureMeasure < ApplicationRecord
  belongs_to :temperature_sensor, optional: true
end
