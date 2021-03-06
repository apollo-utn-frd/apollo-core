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

  def authenticate_unconfirmed_user!
    return if current_user.present?

    raise Apollo::UserNotAuthorized if request.content_type == 'application/json'

    redirect_to root_path
  end

  def authenticate_user!
    if current_user.present?
      if current_user.enabled?
        redirect_to edit_user_path(current_user.format_id) unless current_user.confirmed?
      else
        session[:user_id] = nil
        redirect_to root_path
      end
    elsif request.content_type == 'application/json'
      raise Apollo::UserNotAuthorized
    else
      redirect_to root_path
    end
  end
end
