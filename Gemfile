source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Ruby on Rails
# https://github.com/rails/rails
gem 'rails', '~> 5.1.2'

# Use Puma as the app server
# https://github.com/puma/puma
gem 'puma', '~> 3.7'

# This is a small gem which causes rails console to open pry
# https://github.com/rweng/pry-rails
gem 'pry-rails'

# Pg is the Ruby interface to the PostgreSQL RDBMS
# https://bitbucket.org/ged/ruby-pg/wiki/Home
gem 'pg', '~> 0.20.0'

# PostGIS ActiveRecord Adapter
# https://github.com/rgeo/activerecord-postgis-adapter
gem 'activerecord-postgis-adapter'

# Prevent downtime in migrations
# https://github.com/LendingHome/zero_downtime_migrations
gem 'zero_downtime_migrations'

# Override migration methods to support UUID columns without having to be
# explicit about it
# https://github.com/fnando/ar-uuid
gem 'ar-uuid'

# Simple, efficient background processing for Ruby
# https://github.com/mperham/sidekiq
gem 'sidekiq', '~> 5.0.2'

# Use Redis adapter to run Action Cable in production
# https://github.com/redis/redis-rb
gem 'redis', '~> 3.0'

# Flexible authentication solution for Rails with Warden
# https://github.com/plataformatec/devise
gem 'devise'

# Token based authentication for Rails JSON APIs
# https://github.com/lynndylanhurley/devise_token_auth
gem 'devise_token_auth'

# Oauth2 strategy for Google
# https://github.com/zquestz/omniauth-google-oauth2
gem 'omniauth-google-oauth2'

# Provides a simple interface to the Google Static Maps V2 API
# https://github.com/thhermansen/google_static_maps_helper
gem 'google_static_maps_helper'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
# https://github.com/cyu/rack-cors
gem 'rack-cors'

# Build JSON APIs with ease
# https://github.com/rails/jbuilder
gem 'jbuilder'

# Pagination library
# https://github.com/mislav/will_paginate
gem 'will_paginate'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# https://github.com/tzinfo/tzinfo-data
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development do
  # Annotate Rails classes with schema and routes info
  # https://github.com/ctran/annotate_models
  gem 'annotate'

  # A Ruby static code analyzer
  # https://github.com/bbatsov/rubocop
  gem 'rubocop'

  # The Listen gem listens to file modifications and notifies you about the changes
  # https://github.com/guard/listen
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background
  # https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Code coverage for Ruby
  # https://github.com/colszowka/simplecov
  gem 'simplecov'
end
