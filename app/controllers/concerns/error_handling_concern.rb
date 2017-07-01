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
      message: "Not authorized to #{e.action} #{model_name} with id = '#{resource.id}'"
    }
  end

  def record_not_found(e)
    model_name = e.model.to_s.downcase
    id = e.id

    if id.is_a?(Array)
      id_to_s = id.to_s.tr('"', "'")
      message = "Couldn't find all #{model_name} with #{e.primary_key} in #{id_to_s}"
    else
      message = "Couldn't find #{model_name} with #{e.primary_key} = '#{id}'"
    end

    {
      status: 404,
      error: 'Not Found',
      message: message
    }
  end
end
