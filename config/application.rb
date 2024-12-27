require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SoftwareProject
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    Dir[Rails.root.join('config', 'initializers', '**', '*.rb')].sort.each do |initializer|
      load initializer
    end
    # Auto-load channel classes
    config.autoload_paths += %W(#{config.root}/app/channels)
    
    # 启用 Action Cable
    # config.action_cable.mount_path = '/cable'
    # config.action_cable.url = 'ws://localhost:3000/cable' # WebSocket URL
    # config.action_cable.allowed_request_origins = [ "http://127.0.0.1:3000", "http://127.0.0.1:4000" ]
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
