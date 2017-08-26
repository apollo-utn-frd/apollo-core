# frozen_string_literal: true

class ImageCreationJob < ApplicationJob
  def perform(object)
    object.upload_image!
  end
end
