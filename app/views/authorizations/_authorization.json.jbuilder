# frozen_string_literal: true

json.(authorization, :created_at)

json.user do
  json.partial! 'users/user', user: authorization.user
end

json.travel do
  json.partial! 'travels/travel', travel: authorization.travel
end
