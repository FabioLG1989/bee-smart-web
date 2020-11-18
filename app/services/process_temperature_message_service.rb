class ProcessTemperatureMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    @temperature_grid = nil
    @date = date
  end

  def call
    sensors_data = @message.split('|').filter{ |data| !data.empty? }
    @hive.reboot! if sensors_data.all? { |d| d.to_f == 0 } && @hive.last_reboot - Time.current > 1.hour

    TemperatureGrid.find_or_create_by(hive_id: @hive.id)
    i = 0

    sensors_data.each do |sensor_data|
      sensor_uuid = "#{@hive.uuid}:#{i}"
      if sensor_data.to_f != 0.0 && sensor_data.to_i != 127
        integer, decimal = sensor_data.split('.')
        decimal = "%.2f" % (decimal.to_i * 10.0/8)
        sensor_data = [integer, decimal].join('.')
        sensor = TemperatureSensor.find_or_create_by(uuid: sensor_uuid)
        sensor.update!(temperature_grid: @hive.temperature_grid) unless sensor.temperature_grid
        TemperatureMeasure.create!(temperature_sensor: sensor, temperature: sensor_data, measured_at: @date)
      end
      i += 1
    end
  end
end
