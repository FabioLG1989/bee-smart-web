class IncomingPacketJob < ApplicationJob
  def perform(topic, payload)
    IncomingPacketService.call(topic, payload)
  end
end
