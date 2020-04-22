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
    i = 0

    sensors_data.each do |sensor_data|
      sensor_uuid = "#{@hive.uuid}:#{i}"
      # if sensor_data != 0
        sensor = TemperatureSensor.find_or_create_by(uuid: sensor_uuid)
        sensor.update!(temperature_grid: @hive.temperature_grid) unless sensor.temperature_grid
        TemperatureMeasure.create!(temperature_sensor: sensor, temperature: sensor_data, measured_at: @date)
      # end
      i += 1
    end
  end
end
