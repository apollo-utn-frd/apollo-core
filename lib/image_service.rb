# frozen_string_literal: true

module ImageService
  module_function

  def upload(image, public_id, tags = [])
    Cloudinary::Uploader.upload(
      image,
      public_id: public_id,
      format: 'png',
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
end
