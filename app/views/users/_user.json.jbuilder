# frozen_string_literal: true

json.id user.format_id

json.(user, :username, :name, :lastname, :description, :created_at)

json.picture_url user_image_path(user.format_id)

json.travels do
  json.count user.travels.length
  json.href user_travels_path(user.format_id)
end

json.favorites do
  json.count user.favorites.length
  json.href user_favorites_path(user.format_id)
end

json.followers do
  json.count user.followers.length
  json.href user_followers_path(user.format_id)
end

json.followings do
  json.count user.followings.length
  json.href user_followings_path(user.format_id)
end

if user.manageable?(current_user)
  json.(user, :email, :confirmed)

  json.authorizations do
    json.count user.authorizations.length
    json.href user_authorizations_path(user.format_id)
  end
end
