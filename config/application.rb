require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Apollo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.api_only = true

    # Active Job is a framework for declaring jobs and making them run on a variety of queuing
    # backends.
    config.active_job.queue_adapter = :sidekiq

    # Integrating OmniAuth Into Your Rails API
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    # https://stackoverflow.com/questions/33560898/rails-4-devise-rails-api-undefined-method-flash
    # config.middleware.use ActionDispatch::Flash

    if Rails.env.production?
      # Raven / Sentry configuration
      Raven.configure do |config|
        raven_key = Rails.application.secrets.raven_key
        raven_secret = Rails.application.secrets.raven_secret
        raven_id = Rails.application.secrets.raven_id
        config.dsn = "https://#{raven_key}:#{raven_secret}@sentry.io/#{raven_id}"
      end
    end
  end
end
