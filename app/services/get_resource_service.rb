class GetResourceService < ApplicationService
  def initialize(hive, resource)
    @hive = hive
    @resource = resource
  end

  def call
    return unless @hive && @resource

    @mqtt_client.publish(
      "#{@hive.apiary.uuid}/send/get",
      "#{@hive.uuid}%#{@resource}"
    )
  end
end
