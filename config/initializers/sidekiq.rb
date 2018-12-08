# frozen_string_literal: true

redis_url = if ENV['REDIS_PORT'].present?
              # Silly hack to use gitlab's REDIS_URL
              ENV['REDIS_PORT'].sub('tcp://', 'redis://')
            elsif ENV['REDIS_URL'].present?
              ENV['REDIS_URL']
            elsif REDIS_URL.present?
              REDIS_URL
            end

Sidekiq.configure_server do |config|
  pool_size = ENV.fetch('REDIS_POOL_SIZE', 12).to_i
  if redis_url.present?
    config.redis = {
      url: redis_url,
      size: pool_size
    }
  end
  ActiveRecord::Base.configurations['production']['pool'] = pool_size
  ActiveRecord::Base.establish_connection
end

Sidekiq.configure_client do |config|
  if redis_url.present?
    config.redis = {
      url: redis_url,
      size: ENV.fetch('REDIS_CLIENT_SIZE', 5).to_i
    }
  end
end
