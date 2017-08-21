# frozen_string_literal: true

if Rails.env.development?
  # Perform Sidekiq jobs immediately in development,
  # so you don't have to run a separate process.
  # You'll also benefit from code reloading.
  require 'sidekiq/testing'

  Sidekiq::Testing.inline!
else
  Sidekiq.configure_server do |config|
    pool_size = ENV.fetch('WORKER_COUNT', 10).to_i + 2

    config.redis = {
      url: ENV['REDIS_URL'],
      size: pool_size
    }

    ActiveRecord::Base.configurations['production']['pool'] = pool_size
    ActiveRecord::Base.establish_connection
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: ENV['REDIS_URL'],
      size: 5
    }
  end
end
