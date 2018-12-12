# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
end

require 'sidekiq/testing'
Sidekiq::Testing.fake!

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def auth_env
    auth_env_as(users(:mati))
  end

  def auth_env_as(user)
    token = user.tokens.to_a.sample

    {
      'UID' => user.uid,
      'Access-Token' => token&.second&.dig('token'),
      'Client' => token&.first
    }
  end

  def response_body
    JSON(response.body, symbolize_names: true)
  end

  def response_id
    response_body[:id]
  end
end
