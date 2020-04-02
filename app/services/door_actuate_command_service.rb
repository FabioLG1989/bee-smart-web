class DoorActuateCommandService < ApplicationService
  def initialize(door)
    @door = door
  end

  def call
    return unless @door

    @mqtt_client.publish(
      "#{@door.hive.apiary.uuid}/send/post",
      "#{@door.hive.uuid}%#{RESOURCE_DOOR}%#{Door.last_commands[@door.last_command]}"
    )
  end
end
