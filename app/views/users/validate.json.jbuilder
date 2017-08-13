# frozen_string_literal: true

json.valid @errors.empty?

json.errors @errors do |error|
  json.attribute error.fetch(:attribute)
  json.detail error.fetch(:detail)
  json.message error.fetch(:message)
end
