# frozen_string_literal: true

# == Schema Information
#
# Table name: places
#
#  id          :uuid             not null, primary key
#  coordinates :geography({:srid point, 4326
#  title       :string           default(""), not null
#  description :text             default(""), not null
#  travel_id   :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (travel_id => travels.id) ON DELETE => cascade
#

class Place < ApplicationRecord
  belongs_to :travel, inverse_of: :places

  validates :title, length: { in: 1..65 }
  validates :description, length: { maximum: 150 }

  validate :validate_coordinates

  delegate :lat, to: :coordinates
  delegate :lon, to: :coordinates

  alias lng lon

  private

  ##
  # Valida el formato de las coordenadas.
  #
  def validate_coordinates
    return if coordinates.present?

    errors.add(:coordinates, :bad_format)
  end
end
