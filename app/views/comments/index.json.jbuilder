# frozen_string_literal: true

comments = @comments.readables(current_user).paginate(params)

json.partial! 'comments/comment', collection: comments, as: :comment
