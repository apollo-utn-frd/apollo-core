# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  class_methods do
    ##
    # Devuelve la ruta de la carpeta donde se deben guardar los archivos.
    #
    def images_folder
      "#{Rails.public_path}/#{table_name}"
    end
  end

  ##
  # Devuelve si la imagen existe.
  #
  def image?
    image_filename.present?
  end

  ##
  # Devuelve el nombre por defecto de la imagen.
  #
  def default_image_filename
    image_filename.presence || "#{format_id}.jpg"
  end

  ##
  # Devuelve la ruta completa de la imagen dado el nombre del archivo.
  #
  def image_path(filename = image_filename)
    "#{self.class.images_folder}/#{filename}"
  end

  ##
  # Devuelve la imagen.
  #
  def image
    return unless has_image?

    File.open(image_filename)
  end

  ##
  # Asigna la imagen.
  #
  def image=(file)
    validate_image(file)

    path = image_path(default_image_filename)

    ImageService.convert(file.path, 'jpg')
    save_file = ImageService.save(file, path)

    self.image_filename = default_image_filename

    save_file
  end

  ##
  # Devuelve si el thumbnail existe.
  #
  def thumbnail?
    thumbnail_filename.present?
  end

  ##
  # Devuelve el nombre por defecto del thumbnail.
  #
  def default_thumbnail_filename
    thumbnail_filename.presence || "#{format_id}_thumbnail.jpg"
  end

  ##
  # Devuelve la ruta completa del thumbnail dado el nombre del archivo.
  #
  def thumbnail_path(filename = thumbnail_filename)
    "#{self.class.images_folder}/#{filename}"
  end

  ##
  # Devuelve el thumbnail.
  #
  def thumbnail
    return unless has_thumbnail?

    File.open(thumbnail_filename)
  end

  ##
  # Asigna el thumbnail.
  #
  def thumbnail=(file)
    path = thumbnail_path(default_thumbnail_filename)

    ImageService.save(file, path)

    self.thumbnail_filename = default_thumbnail_filename

    file
  end

  private

  ##
  # Devuelve si el tamaño de la imagen es valido.
  #
  def valid_image_size?(file)
    file.size < 3.megabytes
  end

  ##
  # Devuelve si el tipo de la imagen es valido.
  #
  def valid_image_content_type?(file)
    ImageService.valid?(file.path)
  end

  ##
  # Valida el tamaño de la imagen.
  #
  def validate_image_size(file)
    return if valid_image_size?(file)

    errors.add(:image, :image_too_big)
  end

  ##
  # Valida el tipo de la imagen.
  #
  def validate_image_content_type(file)
    return if valid_image_content_type?(file)

    errors.add(:image, :invalid_image)
  end

  ##
  # Valida la imagen.
  #
  def validate_image(file)
    validate_image_size(file)
    validate_image_content_type(file)

    raise ActiveRecord::RecordInvalid.new(self) if errors.present?
  end
end
