class SubscribeApiaryService < ApplicationService
  def initialize(uuids: nil)
    @uuids = uuids
    @uuids = Apiary.all.pluck(:uuid) unless @uuids
    @uuids = [@uuids] unless @uuids.is_a?(Array)
  end

  def call
    @uuids.each do |uuid|
      @mqtt_client.subscribe("#{uuid}/data", IncomingPacketService)
    end
  end
end
