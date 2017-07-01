# frozen_string_literal: true

class SetPictureJob < ApplicationJob
  queue_as :pictures

  PUBLIC_FOLDER = 'public'
  VIEWS_FOLDER = 'app/views/'

  def perform(object)
    filename = filename(object)

    path = picture_folder(object) + filename
    download_picture!(object, path) || copy_default_picture!(object, path)

    object.update!(picture_local_path: filename)
  end

  def download_picture!(object, path)
    ImageService.download(object.picture_url, path)
  end

  def copy_default_picture!(object, path)
    ImageService.copy(default_picture_path(object), path)
  end

  def filename(object)
    "#{object.format_id}.jpg"
  end

  def picture_folder(object)
    "#{PUBLIC_FOLDER}/#{object.class.table_name}/"
  end

  def default_picture_path(object)
    "#{VIEWS_FOLDER}/#{object.class.table_name}/images/default.jpg"
  end
end
