# frozen_string_literal: true

travels = @travels.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'travels/travel', collection: travels, as: :travel
