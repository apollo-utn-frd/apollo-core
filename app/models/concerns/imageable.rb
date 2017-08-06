# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  class_methods do
    def images_folder
      "#{Rails.public_path}/#{table_name}"
    end
  end

  def image?
    image_filename.present?
  end

  def default_image_filename
    image_filename.presence || "#{format_id}.jpg"
  end

  def image_path(filename = image_filename)
    "#{self.class.images_folder}/#{filename}"
  end

  def image
    return unless has_image?

    File.open(image_filename)
  end

  def image=(file)
    validate_image(file)

    path = image_path(default_image_filename)

    ImageService.convert(file.path, 'jpg')
    save_file = ImageService.save(file, path)

    self.image_filename = default_image_filename

    save_file
  end

  def thumbnail?
    thumbnail_filename.present?
  end

  def default_thumbnail_filename
    thumbnail_filename.presence || "#{format_id}_thumbnail.jpg"
  end

  def thumbnail_path(filename = thumbnail_filename)
    "#{self.class.images_folder}/#{filename}"
  end

  def thumbnail
    return unless has_thumbnail?

    File.open(thumbnail_filename)
  end

  def thumbnail=(file)
    path = thumbnail_path(default_thumbnail_filename)

    ImageService.save(file, path)

    self.thumbnail_filename = default_thumbnail_filename

    file
  end

  private

  def valid_image_size?(file)
    file.size < 3.megabytes
  end

  def valid_image_content_type?(file)
    ImageService.valid?(file.path)
  end

  def validate_image_size(file)
    return if valid_image_size?(file)

    errors.add('image', 'size should be less than 3 MB')
  end

  def validate_image_content_type(file)
    return if valid_image_content_type?(file)

    errors.add('image', 'content type must be a image type')
  end

  def validate_image(file)
    validate_image_size(file)
    validate_image_content_type(file)

    raise ActiveRecord::RecordInvalid.new(self) if errors.present?
  end
end
