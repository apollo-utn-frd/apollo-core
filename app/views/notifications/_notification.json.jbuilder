# frozen_string_literal: true

json.(notification, :readed)

json.partial! 'events/event', event: notification.event
