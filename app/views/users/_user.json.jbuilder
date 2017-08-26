# frozen_string_literal: true

json.id user.format_id

json.(user, :username, :name, :lastname, :description, :created_at)

json.image_url user.image_public_url
json.thumbnail_url user.thumbnail_public_url

if user.manageable?(current_user)
  json.(user, :email, :confirmed)

  json.authorizations do
    json.count user.authorizations.readables(current_user).length
    json.href user_authorizations_path(user.format_id)
  end
end

json.travels do
  json.count user.travels.readables(current_user).length
  json.href user_travels_path(user.format_id)
end

json.favorites do
  json.count user.favorites.readables(current_user).length
  json.href user_favorites_path(user.format_id)
end

json.followers do
  json.count user.followers.readables(current_user).length
  json.href user_followers_path(user.format_id)
end

json.followings do
  json.count user.followings.readables(current_user).length
  json.href user_followings_path(user.format_id)
end
