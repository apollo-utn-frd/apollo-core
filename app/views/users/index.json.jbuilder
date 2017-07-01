# frozen_string_literal: true

users = @users.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'users/user', collection: users, as: :user
