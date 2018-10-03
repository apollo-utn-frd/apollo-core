# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection
  include ErrorHandlingConcern

  helper_method :current_user

  protect_from_forgery unless: -> { request.format.json? }

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    return if current_user.present?

    raise Apollo::UserNotAuthorized.new
  end
end
