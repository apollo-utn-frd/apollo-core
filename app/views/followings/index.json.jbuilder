# frozen_string_literal: true

followings = @followings.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'followings/following', collection: followings, as: :following
