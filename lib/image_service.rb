# frozen_string_literal: true

module ImageService
  mattr_accessor :cloudinary_url, :format

  module_function

  def upload(image, public_id, tags = [])
    Cloudinary::Uploader.upload(
      image,
      public_id: public_id,
      format: format,
      tags: Array(tags) + [Rails.env],
      eager: {
        transformation: 'media_lib_thumb'
      }
    )
  end

  def from_base64(base)
    tempfile = Tempfile.new
    IO.binwrite(tempfile, Base64.decode64(base))
    tempfile
  end

  def valid?(path)
    MiniMagick::Image.new(path).valid?
  end

  def url(public_id)
    "#{cloudinary_url}/image/upload/#{public_id}.#{format}"
  end

  def thumbnail_url(public_id)
    "#{cloudinary_url}/image/upload/t_media_lib_thumb/#{public_id}.#{format}"
  end
end
