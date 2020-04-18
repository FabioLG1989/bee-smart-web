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
      host: ENV['MQTT_HOST'],
      port: ENV['MQTT_PORT'],
      username: ENV['MQTT_USERNAME'],
      password: ENV['MQTT_PASSWORD']
    }


    config.after_initialize do
      if ActiveRecord::Base.connection.data_source_exists? 'apiaries'
        config.mqtt_client = MqttClient.new(config.mqtt_client_configuration)
        SubscribeApiaryService.call
      end
    end

    ActionMailer::Base.smtp_settings = {
      domain:         ENV['SENDGRID_DOMAIN'],
      address:        "smtp.sendgrid.net",
      port:            587,
      authentication: :plain,
      user_name:      'apikey',
      password:       ENV['SENDGRID_API_KEY']
    }
  end
end
