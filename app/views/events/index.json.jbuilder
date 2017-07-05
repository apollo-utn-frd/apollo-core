# frozen_string_literal: true

events = @events.readables(current_user).paginate(params)

json.partial! 'events/event', collection: events, as: :event
