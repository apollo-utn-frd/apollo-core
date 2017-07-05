# frozen_string_literal: true

users = @users.readables(current_user).paginate(params)

json.partial! 'users/user', collection: users, as: :user
