# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  ###
  # Devuelve el id sin guiones.
  #
  def format_id
    self.id.delete('-')
  end

  ###
  # Devuelve una lista de los errores de validación con el atributo, el error
  # tipificado y un mensaje.
  #
  def details_errors
    validate

    errors.details.flat_map do |attribute, details|
      details.map.with_index do |detail, index|
        {
          attribute: attribute,
          detail: detail,
          message: errors.messages[attribute][index]
        }
      end
    end
  end
end
