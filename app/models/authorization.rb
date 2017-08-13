# frozen_string_literal: true

# == Schema Information
#
# Table name: authorizations
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  travel_id  :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (travel_id => travels.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#

class Authorization < ApplicationRecord
  belongs_to :user
  belongs_to :travel

  has_one :event, as: :resource, dependent: :destroy

  validates :user_id, uniqueness: { scope: :travel_id }

  validate :validate_user_following
  validate :validate_user_not_same
  validate :validate_travel_private

  after_create_commit :create_event!

  ##
  # Devuelve si la autorizacion puede ser accedida por un determinado usuario.
  #
  delegate :readable?, to: :travel

  private

  ##
  # Valida que el viaje sea privado
  #
  def validate_travel_private
    return unless travel.publicx?

    errors.add(:travel_id, :public)
  end

  ##
  # Valida que el usuario siga al creador del viaje.
  #
  def validate_user_following
    return if user.follow?(travel.user)
    return if user == travel.user

    errors.add(:user_id, :not_follower)
  end

  ##
  # Valida que el usuario no sea el creador del viaje.
  #
  def validate_user_not_same
    return if user != travel.user

    errors.add(:user_id, :authorize_himself)
  end

  ##
  # Crea el evento de la creación de la autorización.
  #
  def create_event!
    EventCreationJob.perform_later(
      source: travel.user,
      resource: self,
      notify_to: user
    )
  end
end
