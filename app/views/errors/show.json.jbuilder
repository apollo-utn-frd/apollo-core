# frozen_string_literal: true

json.errors do
  json.partial! 'errors/error', error: @error
end
