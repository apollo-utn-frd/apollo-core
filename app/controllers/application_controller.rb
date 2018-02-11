# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::RequestForgeryProtection
  include ErrorHandlingConcern

  protect_from_forgery unless: -> { request.format.json? }

  before_action :set_response_format
  before_action :authenticate_user

  protected

  def set_response_format
    request.format = :json
  end

  def authenticate_user
    return unless Rails.env.test?

    user = User.find_by(uid: request.headers[:UID])
    token = request.headers['Access-Token']

    if user.present? && token.present? && user.tokens[request.headers['Client']]&.fetch('token') == token
      @current_user = user
    end
  end

  def authenticate_user!
    return super unless Rails.env.test?

    user = User.find_by!(uid: request.headers[:UID])
    token = request.headers['Access-Token']

    if token.present? && user.tokens[request.headers['Client']]&.fetch('token') == token
      @current_user = user
    else
      raise Apollo::UserNotAuthorized
    end
  end
end
