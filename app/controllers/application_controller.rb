# frozen_string_literal: true
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::RequestForgeryProtection
  include ErrorHandlingConcern

  protect_from_forgery unless: -> { request.format.json? }
end
