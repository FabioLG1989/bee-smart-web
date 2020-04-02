class TemperatureSensor < ApplicationRecord
  belongs_to :temperature_grid, optional: true
  has_many :temperature_measures, dependent: :destroy
end
