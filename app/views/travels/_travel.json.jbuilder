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
  json.count travel.favorites.length
  json.href travel_favorites_path(travel.format_id)
end

json.comments do
  json.count travel.comments.length
  json.href travel_comments_path(travel.format_id)
end

json.authorizations do
  json.count travel.authorizations.length
  json.href travel_authorizations_path(travel.format_id)
end
