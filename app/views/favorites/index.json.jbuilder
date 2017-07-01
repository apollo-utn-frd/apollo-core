# frozen_string_literal: true

favorites = @favorites.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'favorites/favorite', collection: favorites, as: :favorite
