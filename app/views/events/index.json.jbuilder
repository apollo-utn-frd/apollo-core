# frozen_string_literal: true

events = @events.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'events/event', collection: events, as: :event
