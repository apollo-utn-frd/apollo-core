# frozen_string_literal: true

authorizations = @authorizations.readables(current_user).paginate(params)

json.partial! 'authorizations/authorization', collection: authorizations, as: :authorization
