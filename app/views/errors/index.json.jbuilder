# frozen_string_literal: true

json.errors do
  json.partial! 'errors/error', collection: @errors, as: :error
end
