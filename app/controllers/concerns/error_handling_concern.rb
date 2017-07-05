# frozen_string_literal: true

module ErrorHandlingConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found
    rescue_from Apollo::UserNotAuthorized, with: :rescue_user_not_authorized
  end

  private

  def rescue_user_not_authorized(e)
    render json: user_not_authorized(e), status: :forbidden
  end

  def rescue_record_not_found(e)
    render json: record_not_found(e), status: :not_found
  end

  def user_not_authorized(e)
    resource = e.resource
    model_name = resource.class.to_s.downcase

    {
      status: 403,
      error: 'Forbidden',
      message: "Not authorized to #{e.action} #{model_name} with id = '#{resource.format_id}'"
    }
  end

  def record_not_found(e)
    model_name = e.model.to_s.downcase

    {
      status: 404,
      error: 'Not Found',
      message: "Couldn't find #{model_name} with #{e.primary_key} = '#{e.id}'"
    }
  end
end
