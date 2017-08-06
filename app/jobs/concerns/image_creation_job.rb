# frozen_string_literal: true

class ImageCreationJob < ApplicationJob
  def perform(object)
    image = download_image(object) || default_image(object)

    object.image = image
    object.save!

    ThumbnailCreationJob.perform_later(object)
  ensure
    image.close
    image.unlink
  end

  private

  def download_image(object)
    open(object.image_url)
  rescue StandardError
    nil
  end

  def default_image(object)
    tempfile = Tempfile.new("#{object.class.table_name}_#{object.id}")
    tempfile.binmode

    File.open(default_path(object), 'rb') do |default_file|
      IO.binwrite(tempfile, default_file.read)
    end

    tempfile
  end

  def default_path(object)
    "app/views/#{object.class.table_name}/images/default.jpg"
  end
end
