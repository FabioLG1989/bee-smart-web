class ProcessWeightMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    Scale.create(hive: @hive) unless @hive.scale
    @scale = @hive.scale
    @date = date
  end

  def call
    ScaleMeasure.create!(scale: @scale, raw: @message.to_i(16), measured_at: @date)
  end
end
