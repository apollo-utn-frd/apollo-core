# frozen_string_literal: true
# == Schema Information
#
# Table name: events
#
#  id            :uuid             not null, primary key
#  type          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  source_type   :string
#  source_id     :uuid             not null
#  resource_type :string
#  resource_id   :uuid             not null
#
# Indexes
#
#  index_events_on_resource_type_and_resource_id  (resource_type,resource_id)
#  index_events_on_source_type_and_source_id      (source_type,source_id)
#

class Event < ApplicationRecord
  self.inheritance_column = nil

  TYPES = %w[
    authorization
    comment
    favorite
    following
    user
    travel
  ].freeze

  CLASS_TYPES = %w[
    Authorization
    Comment
    Favorite
    Following
    User
    Travel
  ].freeze

  belongs_to :source, polymorphic: true
  belongs_to :resource, polymorphic: true

  has_many :notifications, dependent: :destroy

  validates :type, inclusion: { in: TYPES }
  validates :source_type, inclusion: { in: CLASS_TYPES }
  validates :resource_type, inclusion: { in: CLASS_TYPES }

  before_validation :set_type

  scope :posts, -> { where(type: %w[comment favorite following user travel]) }
  scope :source, ->(source) { where(source: source) }
  scope :resource, ->(resource) { where(resource: resource) }

  ##
  # Devuelve si el evento puede ser accedido por un determinado usuario.
  #
  def readable?(user)
    source.readable?(user) && resource.readable?(user)
  end

  ##
  # Notifica a una lista de usuarios del evento. Devuelve los usuarios que se
  # pudieron notificar correctamente.
  #
  def notify!(users)
    Array(users).select do |user|
      user.notify!(self)
    end
  end

  private

  def set_type
    self.type = resource_type.downcase
  end
end
