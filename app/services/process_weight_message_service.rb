class ProcessWeightMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    Scale.create(hive: @hive) unless @hive.scale
    @scale = @hive.scale
    @date = date
  end

  def call
    @scale.update!(next_tare: false, tare: @message.to_i(16)) if @scale.next_tare

    @scale.update!(next_slope: nil, slope: (@message.to_i(16) - @scale.tare) / @scale.next_slope) if @scale.next_slope

    ScaleMeasure.create!(scale: @scale, raw: @message.to_i(16), measured_at: @date)
  end
end
