class TemperatureGrid < ApplicationRecord
  belongs_to :hive, optional: true
  has_many :temperature_sensors, dependent: :destroy
end
