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

  def fetch_user
    if Rails.env.test?
      User.find_by(uid: request.headers['UID'])
    elsif session[:user_id]
      User.find(session[:user_id])
    end
  end

  def authenticate_user!
    return if current_user.present?

    raise Apollo::UserNotAuthorized.new
  end
end
