# frozen_string_literal: true

# == Schema Information
#
# Table name: followings
#
#  id           :uuid             not null, primary key
#  following_id :uuid             not null
#  follower_id  :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (follower_id => users.id) ON DELETE => cascade
#  fk_rails_...  (following_id => users.id) ON DELETE => cascade
#

class Following < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :following, class_name: User.name

  has_one :event, as: :resource, dependent: :destroy

  validates :follower_id, uniqueness: { scope: :following_id }

  validate :validate_following

  after_create_commit :create_event!

  ##
  # Devuelve si el seguimiento puede ser accedido por un determinado usuario.
  #
  def readable?(_user)
    true
  end

  private

  ##
  # Valida el seguimiento.
  #
  def validate_following
    return if valid_following?

    errors.add(:follower_id, :follow_himself)
  end

  ##
  # Devuelve si el seguimiento es válido.
  #
  def valid_following?
    follower != following
  end

  ##
  # Crea el evento de la creación del seguimiento.
  #
  def create_event!
    EventCreationJob.perform_later(
      source: follower,
      resource: self,
      notify_to: following
    )
  end
end
