class Hive < ApplicationRecord
  belongs_to :apiary, optional: true
  has_one :temperature_grid, dependent: :destroy
  has_one :door, dependent: :destroy
  has_one :scale, dependent: :destroy
end
