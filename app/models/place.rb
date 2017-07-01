# frozen_string_literal: true
# == Schema Information
#
# Table name: places
#
#  id          :uuid             not null, primary key
#  lonlat      :geography({:srid point, 4326
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

  validates :title, length: { maximum: 30 }
  validates :description, length: { maximum: 150 }

  validate :validate_lonlat

  def lat
    lonlat.lat
  end

  def lng
    lonlat.lon
  end

  private

  def validate_lonlat
    return if lonlat.present?

    errors.add('longitude', 'or latitude is invalid')
  end
end
