class ProcessTemperatureMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    @temperature_grid = nil
    @date = date
  end

  def call
    sensors_data = @message.split('|').filter{ |data| !data.empty? }
    first_sensor = TemperatureSensor.find_by(uuid: sensors_data.first.split('-'))

    if first_sensor
      @temperature_grid = first_sensor.temperature_grid
      unless @temperature_grid
        @temperature_grid = TemperatureGrid.create!(hive: @hive)
      end
    else
      @temperature_grid = TemperatureGrid.create!(hive: @hive)
    end

    sensors_data.each do |sensor_data|
      sensor_uuid, sensor_temperature = sensor_data.split('-')
      sensor = TemperatureSensor.find_or_create_by(uuid: sensor_uuid)
      sensor.update!(temperature_grid: @temperature_grid) unless sensor.temperature_grid
      TemperatureMeasure.create!(temperature_sensor: sensor, temperature: sensor_temperature, measured_at: @date)
    end
  end
end
