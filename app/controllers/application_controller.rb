# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::RequestForgeryProtection
  include ErrorHandlingConcern

  protect_from_forgery unless: -> { request.format.json? }

  before_action :authenticate_user

  protected

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
