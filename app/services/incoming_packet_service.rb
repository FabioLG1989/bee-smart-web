class IncomingPacketService < ApplicationService
  def initialize(packet)
    @packet = packet
  end

  def call
    Message.create(raw: "#{@packet.topic} --> #{@packet.payload}")
  end
end
