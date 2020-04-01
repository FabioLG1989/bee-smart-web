class Hive < ApplicationRecord
  belongs_to :apiary, optional: true
  has_one :temperature_grid
  has_one :door
  has_one :scale
end
