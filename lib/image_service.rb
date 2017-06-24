# frozen_string_literal: true
require 'open-uri'

module ImageService
  module_function

  def download(url, path_to)
    open(url) do |f|
      File.open(path_to, 'wb') { |file| file.puts f.read }
    end

    path_to
  rescue StandardError
    nil
  end

  def copy(path_from, path_to)
    FileUtils.cp(path_from, path_to)

    path_to
  end
end
