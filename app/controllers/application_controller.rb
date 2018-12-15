# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection
  include ErrorHandlingConcern

  helper_method :current_user

  protect_from_forgery unless: -> { request.format.json? }

  protected

  def current_user
    @current_user ||= fetch_user
  end

  def authorization_token
    token = ActionController::HttpAuthentication::Token
    token.token_and_options(request)&.first
  end

  def fetch_user
    if session[:user_id].present?
      User.find_by(id: session[:user_id])
    elsif authorization_token.present?
      User.find_by(uid: authorization_token)
    end
  end

  def authenticate_user!
    return if current_user.present?

    raise Apollo::UserNotAuthorized if request.content_type == 'application/json'

    redirect_to root_path
  end
end
