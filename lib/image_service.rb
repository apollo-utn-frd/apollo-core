# frozen_string_literal: true

module ImageService
  module_function

  def save(file, path_to)
    File.open(path_to, 'wb') { |file_to| file_to.puts file.read }
  end

  def thumbnail(path, size = '75x75')
    MiniMagick::Image.open(path).resize(size).tempfile.open
  end

  def convert(path, to_format)
    MiniMagick::Image.new(path).format(to_format)
  end

  def valid?(path)
    MiniMagick::Image.new(path).valid?
  end
end
