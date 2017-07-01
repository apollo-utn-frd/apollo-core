# frozen_string_literal: true

json.id comment.format_id

json.(comment, :content, :created_at)

json.user do
  json.partial! 'users/user', user: comment.user
end

json.travel do
  json.partial! 'travels/travel', travel: comment.travel
end
