# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection
  include ErrorHandlingConcern

  helper_method :current_user

  protect_from_forgery unless: -> { request.format.json? }

  before_action :authenticate_user

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    return unless Rails.env.test?

    user = User.find_by(uid: request.headers[:UID])
    user_token = user.tokens[request.headers['Client']]&.fetch('token')
    token = request.headers['Access-Token']

    return if user.blank?
    return if token.blank?
    return unless ActiveSupport::SecurityUtils.secure_compare(token, user_token)

    @current_user = user
  end

  def authenticate_user!
    return super unless Rails.env.test?

    user = User.find_by!(uid: request.headers[:UID])
    user_token = user.tokens[request.headers['Client']]&.fetch('token')
    token = request.headers['Access-Token']

    if token.blank? || !ActiveSupport::SecurityUtils.secure_compare(token, user_token)
      raise Apollo::UserNotAuthorized
    end

    @current_user = user
  end
end
