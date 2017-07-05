# frozen_string_literal: true

travels = @travels.readables(current_user).paginate(params)

json.partial! 'travels/travel', collection: travels, as: :travel
