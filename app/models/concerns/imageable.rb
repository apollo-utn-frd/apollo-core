# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  def upload_image!(image = nil)
    return unless Rails.env.production?

    cdn_image = upload_image_cdn!(image)

    update!(
      image_public_url: cdn_image['secure_url'],
      thumbnail_public_url: cdn_image['eager'].first['secure_url']
    )
  end

  def image_public_default_url
    ImageService.url(image_public_id)
  end

  def thumbnail_public_default_url
    ImageService.thumbnail_url(image_public_id)
  end

  private

  def upload_image_cdn!(image = nil)
    image_param = image.presence || image_url

    ImageService.upload(image_param, image_public_id, table_name)
  rescue => e
    errors.add(:image, e.message)
    raise ActiveRecord::RecordInvalid.new(self)
  end

  def image_public_id
    "#{table_name}/#{format_id}"
  end
end
