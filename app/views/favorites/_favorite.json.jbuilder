# frozen_string_literal: true

json.(favorite, :created_at)

json.user do
  json.partial! 'users/user', user: favorite.user
end

json.travel do
  json.partial! 'travels/travel', travel: favorite.travel
end
