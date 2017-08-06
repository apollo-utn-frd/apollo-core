# frozen_string_literal: true

class ThumbnailCreationJob < ApplicationJob
  queue_as :thumbnails

  def perform(object)
    return unless object.image?

    object.thumbnail = ImageService.thumbnail(object.image_path)
    object.save!
  end
end
