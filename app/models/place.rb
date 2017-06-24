# frozen_string_literal: true
# == Schema Information
#
# Table name: places
#
#  id         :uuid             not null, primary key
#  latitude   :string           not null
#  longitude  :string           not null
#  travel_id  :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (travel_id => travels.id) ON DELETE => cascade
#

class Place < ApplicationRecord
  belongs_to :travel, inverse_of: :places

  validates :latitude, format: { with: /\A[+-]?[0-9]+\.[0-9]+\z/ }
  validates :longitude, format: { with: /\A[+-]?[0-9]+\.[0-9]+\z/ }
  validates :title, length: { in: 0..30 }, presence: true
  validates :description, length: { in: 0..150 }

  alias_attribute :lat, :latitude
  alias_attribute :lng, :longitude
end
