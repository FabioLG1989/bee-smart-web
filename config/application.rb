require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BeeSmart
  class Application < Rails::Application
    config.load_defaults 6.0
    config.autoload_paths += %W( lib/ )
    config.mqtt_client_configuration = {
      host: 'beesmart.cure.edu.uy',
      port: 2000,
      username: 'pfc',
      password: 'pfc'
    }


    config.after_initialize do
      config.mqtt_client = MqttClient.new(config.mqtt_client_configuration)
      config.mqtt_client.subscribe('colmena1/data', IncomingPacketService)
      config.mqtt_client.publish('test/rails', "HOLA MUNDO!")
    end
  end
end
