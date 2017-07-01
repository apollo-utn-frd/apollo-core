# frozen_string_literal: true

json.(following, :created_at)

json.follower do
  json.partial! 'users/user', user: following.follower
end

json.following do
  json.partial! 'users/user', user: following.following
end
