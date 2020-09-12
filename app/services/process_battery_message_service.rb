class ProcessBatteryMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    Battery.create(hive: @hive) unless @hive.battery
    @battery = @hive.battery
    @date = date
  end

  def call
    BatteryMeasure.create!(battery: @battery, voltage: @message.to_i, measured_at: @date)
  end
end
