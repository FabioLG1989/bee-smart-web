class MqttClient
  def initialize(configuration)
    @client = PahoMqtt::Client.new({ username: configuration[:username], password: configuration[:password] })
    @client.connect(
      configuration[:host],
      configuration[:port],
      @client.keep_alive,
      true
    )
  end

  def subscribe(topic, service, qos: 2)
    subscription_callback = lambda { |packet| service.send(:call, packet) }
    @client.subscribe([topic, qos])
    @client.add_topic_callback(topic, subscription_callback)
  end

  def publish(topic, payload, qos: 0)
    @client.publish(topic, payload, false, qos)
  end
end
