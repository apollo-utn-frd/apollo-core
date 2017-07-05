# frozen_string_literal: true

json.id travel.format_id

json.(travel, :title, :description, :created_at)

json.user do
  json.partial! 'users/user', user: travel.user
end

json.picture_url travel_image_path(travel.format_id)

json.public travel.publicx

json.places travel.places do |place|
  json.partial! 'places/place', place: place
end

json.favorites do
  json.count travel.favorites.readables(current_user).length
  json.href travel_favorites_path(travel.format_id)
end

json.comments do
  json.count travel.comments.readables(current_user).length
  json.href travel_comments_path(travel.format_id)
end

json.authorizations do
  json.count travel.authorizations.readables(current_user).length
  json.href travel_authorizations_path(travel.format_id)
end
