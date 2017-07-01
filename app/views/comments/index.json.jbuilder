# frozen_string_literal: true

comments = @comments.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'comments/comment', collection: comments, as: :comment
