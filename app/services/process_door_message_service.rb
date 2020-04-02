class ProcessDoorMessageService < ApplicationService
  def initialize(hive, message, date)
    @hive = hive
    @message = message
    Door.create(hive: @hive) unless @hive.door
    @door = @hive.door
    @date = date
  end

  def call
    return if @message.empty?
    if @message.to_i == 0
      @door.status_closed!
    elsif @message.to_i == 1
      @door.status_opened!
    else
      @door.status_unkown!
    end
  end
end
