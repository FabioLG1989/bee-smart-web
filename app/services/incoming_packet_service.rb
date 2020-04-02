class IncomingPacketService < ApplicationService
  def initialize(packet)
    @packet = packet
  end

  def call
    return unless @packet

    Message.create(raw: "#{@packet.topic} --> #{@packet.payload}")
    uuid = @packet.topic.split('/').first
    regexp = /\[(.*?)\]\[(.*?)\]\[(.*?)\]{(.*?)}/
    _, date, hive_uuid, subtopic, data = *@packet.payload.match(regexp)

    return unless date && hive_uuid && subtopic && data
    return if data&.empty?

    hive = Hive.find_or_create_by(uuid: hive_uuid)
    hive.update!(apiary: Apiary.find_by(uuid: uuid))

    date = DateTime.parse(date.gsub(/[\(\)]/, ''))

    case subtopic
    when RESOURCE_DOOR
      ProcessDoorMessageService.call(hive, data, date)
    when RESOURCE_TEMPERATURE
      ProcessTemperatureMessageService.call(hive, data, date)
    when RESOURCE_WEIGHT
      ProcessWeightMessageService.call(hive, data, date)
    end
  end
end
