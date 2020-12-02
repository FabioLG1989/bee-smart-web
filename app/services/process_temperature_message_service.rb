class ProcessTemperatureMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    @temperature_grid = nil
    @date = date
  end

  def call
    sensors_data = @message.split('|').filter{ |data| !data.empty? }
    @hive.reboot! if sensors_data.any? { |d| d.to_f == 0 } && Time.current - @hive.last_reboot > 15.minutes

    TemperatureGrid.find_or_create_by(hive_id: @hive.id)
    i = 0

    sensors_data.each do |sensor_data|
      sensor_uuid = "#{@hive.uuid}:#{i}"
      if valid_meassure(sensor_data)
        integer, decimal = sensor_data.split('.')
        decimal = "%.2f" % (decimal.to_i * 10.0/8)
        sensor_data = [integer, decimal].join('.')
        sensor = TemperatureSensor.find_or_create_by(uuid: sensor_uuid)
        sensor.update!(temperature_grid: @hive.temperature_grid) unless sensor.temperature_grid
        TemperatureMeasure.create!(temperature_sensor: sensor, temperature: unflip_bits(sensor, sensor_data), measured_at: @date)
      end
      i += 1
    end
  end

  def valid_meassure(sensor_data)
    sensor_data.to_f != 0.0 && sensor_data.to_i != 127
  end

  def unflip_bits(sensor, measure)
    last_valid_measure = sensor.temperature_measures.last
    return measure unless last_valid_measure
    difference = measure.to_f - last_valid_measure.to_f
    return measure.to_f - difference.round if [4, 8, 16, 32, 64].include?(difference.round.abs)
    measure
  end
end
