class ApplicationService
  RESOURCE_DOOR = 'actuators/servo'
  RESOURCE_TEMPERATURE = 'sensors/temperature/all'
  RESOURCE_WEIGHT = 'sensors/weight'

  def self.call(*args, &block)
    service = new(*args, &block)
    service.set_client
    service.call
  end

  def set_client
    @mqtt_client = Rails.configuration.mqtt_client
  end
end
