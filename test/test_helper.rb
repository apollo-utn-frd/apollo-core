# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def auth_env
    auth_env_as(users(:mati))
  end

  def auth_env_as(user)
    user.create_new_auth_token
    user.create_new_auth_token
    user.create_new_auth_token
    token = user.tokens.to_a.sample

    {
      'UID' => user.uid,
      'Access-Token' => token.second['token'],
      'Client' => token.first
    }
  end

  def response_body
    JSON(response.body, symbolize_names: true)
  end

  def response_id
    response_body[:id]
  end
end
