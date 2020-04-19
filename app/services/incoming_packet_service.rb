class IncomingPacketService < ApplicationService
  def initialize(topic, payload)
    @topic = topic
    @payload = payload
  end

  def call
    return unless @topic && @payload

    message = Message.create(raw: "#{@topic} --> #{@payload}")
    uuid = @topic.split('/').first
    regexp = /\[(.*?)\]\[(.*?)\]\[(.*?)\]{(.*?)}/
    _, date, hive_uuid, subtopic, data = *@payload.match(regexp)

    return unless date && hive_uuid && subtopic && data
    return if data&.empty?

    hive = Hive.find_or_create_by(uuid: hive_uuid)
    hive.update!(apiary: Apiary.find_by(uuid: uuid))
    message.update!(hive: hive)

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
