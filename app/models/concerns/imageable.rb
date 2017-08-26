# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  def upload_image!(file = nil)
    return unless Rails.env.production?

    cdn_image = upload_image_cdn!(file)

    update!(
      image_public_url: cdn_image['secure_url'],
      thumbnail_public_url: cdn_image['eager'].first['secure_url']
    )
  end

  private

  def upload_image_cdn!(file = nil)
    image = file.presence || image_url

    ImageService.upload(image, image_public_id, table_name)
  rescue => e
    if file.present?
      errors.add(:image, e.message)
      raise ActiveRecord::RecordInvalid.new(self)
    end

    ImageService.upload(image_default_path, image_public_id, table_name)
  end

  def image_default_path
    Rails.root.join('app', 'views', table_name, 'images', 'default.jpg')
  end

  def image_public_id
    "#{table_name}/#{format_id}"
  end
end
