# frozen_string_literal: true

class EventCreationJob < ApplicationJob
  queue_as :events

  def perform(source:, resource:, notify_to: [])
    Event.create!(
      source: source,
      resource: resource
    ).notify!(notify_to)
  end
end
