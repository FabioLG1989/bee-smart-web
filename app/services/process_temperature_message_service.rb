class ProcessTemperatureMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    @temperature_grid = nil
    @date = date
  end

  def call
    sensors_data = @message.split('|').filter{ |data| !data.empty? }

    TemperatureGrid.find_or_create_by(hive_id: @hive.id)

    sensors_data.each do |sensor_data|
      sensor_uuid, sensor_temperature = sensor_data.split('-')
      sensor_uuid = "#{@hive.uuid}:#{sensor_uuid}"
      # if sensor_temperature != 0
        sensor = TemperatureSensor.find_or_create_by(uuid: sensor_uuid)
        sensor.update!(temperature_grid: @hive.temperature_grid) unless sensor.temperature_grid
        TemperatureMeasure.create!(temperature_sensor: sensor, temperature: sensor_temperature, measured_at: @date)
      # end
    end
  end
end
