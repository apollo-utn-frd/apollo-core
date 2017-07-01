# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  ###
  # Devuelve el id sin guiones.
  #
  def format_id
    self.id.delete('-')
  end
end
