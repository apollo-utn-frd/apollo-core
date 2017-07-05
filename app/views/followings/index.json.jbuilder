# frozen_string_literal: true

followings = @followings.readables(current_user).paginate(params)

json.partial! 'followings/following', collection: followings, as: :following
