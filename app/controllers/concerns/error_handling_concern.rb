# frozen_string_literal: true

# rubocop:disable Naming/UncommunicativeMethodParamName

module ErrorHandlingConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from Apollo::UserNotAuthorized, with: :user_not_authorized
  end

  private

  def record_not_found(e)
    model_name = e.model.to_s.underscore

    @error = {
      status: 404,
      error: 'Not Found',
      message: "Couldn't find #{model_name} with #{e.primary_key} = '#{e.id}'"
    }

    render '/errors/show', status: :not_found
  end

  def user_not_authorized(e)
    action = e.action
    resource = e.resource

    message = 'Not authorized'
    message += " to #{action}" if action.present?
    message += " #{resource.class.to_s.downcase}" if resource.present?
    message += " with id = '#{resource.id}'" if resource.try(:id).present?

    @error = {
      status: 403,
      error: 'Forbidden',
      message: message
    }

    render '/errors/show', status: :forbidden
  end

  def record_invalid(e)
    record_errors = e.record.errors

    @errors = record_errors.to_hash(true).flat_map do |_, v|
      v.map do |msg|
        {
          status: 422,
          error: 'Unprocessable Entity',
          message: msg
        }
      end
    end

    render '/errors/index', status: :unprocessable_entity
  end

  def argument_error(e)
    @error = {
      status: 422,
      error: 'Unprocessable Entity',
      message: e.message
    }

    render '/errors/show', status: :unprocessable_entity
  end

  def parameter_missing(e)
    @error = {
      status: 400,
      error: 'Bad Request',
      message: e.message
    }

    render '/errors/show', status: :bad_request
  end
end
