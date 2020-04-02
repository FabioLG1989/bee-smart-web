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
      if ActiveRecord::Base.connection.data_source_exists? 'apiaries'
        config.mqtt_client = MqttClient.new(config.mqtt_client_configuration)
        SubscribeApiaryService.call
      end
    end
  end
end
