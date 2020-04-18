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
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :domain => ENV['SENDGRID_DOMAIN'],
      :address => 'smtp.sendgrid.net',
      :port => 465,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end
end
