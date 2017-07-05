# frozen_string_literal: true

favorites = @favorites.readables(current_user).paginate(params)

json.partial! 'favorites/favorite', collection: favorites, as: :favorite
