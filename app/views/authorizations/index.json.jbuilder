# frozen_string_literal: true

authorizations = @authorizations.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'authorizations/authorization', collection: authorizations, as: :authorization
