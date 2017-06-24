# frozen_string_literal: true
# == Schema Information
#
# Table name: favorites
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

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :travel

  has_one :event, as: :resource, dependent: :destroy

  validates :user_id, uniqueness: {
    scope: :travel_id,
    message: 'already has favorite for this travel'
  }

  validate :validate_travel_readable

  after_create_commit :create_event!

  ##
  # Devuelve si el favorito puede ser accedido por un determinado usuario.
  #
  delegate :readable?, to: :travel

  private

  ##
  # Valida si el favorito puede ser accedido por un determinado usuario.
  #
  def validate_travel_readable
    return if readable?(user)

    errors.add('user_id', 'can not access the travel')
  end

  ##
  # Crea el evento de la creación del favorito.
  #
  def create_event!
    noficable_user = travel.user unless travel.user == user

    CreationEventJob.perform_later(
      source: user,
      resource: self,
      notify_to: noficable_user
    )
  end
end
