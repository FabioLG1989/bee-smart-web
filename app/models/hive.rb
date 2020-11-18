class Hive < ApplicationRecord
  belongs_to :apiary, optional: true
  has_one :temperature_grid, dependent: :destroy
  has_one :door, dependent: :destroy
  has_one :scale, dependent: :destroy
  has_one :battery, dependent: :destroy

  delegate :last_temperature_measure, :last_temperature_measure_date, to: :temperature_grid, allow_nil: true
  delegate :working_positions, :graph_data, :csv_collection, to: :temperature_grid, prefix: true, allow_nil: true
  delegate :last_weight_measure, :last_weight_measure_date, to: :scale, allow_nil: true
  delegate :calibrated, :graph_data, :csv_collection, to: :scale, prefix: true, allow_nil: true
  delegate :last_battery_measure, :last_battery_measure_date, to: :battery, allow_nil: true
  delegate :calibrated, :graph_data, :csv_collection, to: :battery, prefix: true, allow_nil: true
  delegate :status_to_s, :last_command_to_s, to: :door, prefix: true, allow_nil: true

  has_many :messages

  def get_resource(resource)
    GetResourceService.call(self, resource)
  end

  def get_temperature
    get_resource(ApplicationService::RESOURCE_TEMPERATURE)
  end

  def get_weight
    get_resource(ApplicationService::RESOURCE_WEIGHT)
  end

  def get_battery
    get_resource(ApplicationService::RESOURCE_BATTERY)
  end

  def get_door
    get_resource(ApplicationService::RESOURCE_DOOR)
  end

  def close_door!
    return unless door
    door.last_command_close!
    DoorActuateCommandService.call(door)
  end

  def open_door!
    return unless door
    door.last_command_open!
    DoorActuateCommandService.call(door)
  end

  def reboot
    get_resource(ApplicationService::RESOURCE_REBOOT)
  end
end
