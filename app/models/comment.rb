# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :uuid             not null, primary key
#  content    :text             not null
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

class Comment < ApplicationRecord
  include Searchable::Comment

  belongs_to :user
  belongs_to :travel

  has_one :event, as: :resource, dependent: :destroy

  validates :content, length: { in: 1..300 }

  validate :validate_travel_readable

  after_create_commit :create_event!

  ##
  # Devuelve si el comentario puede ser accedido por un determinado usuario.
  #
  delegate :readable?, to: :travel, allow_nil: true

  private

  ##
  # Valida si el comentario puede ser accedido por un determinado usuario.
  #
  def validate_travel_readable
    return if readable?(user)

    errors.add(:user_id, :unauthorized_travel)
  end

  ##
  # Crea el evento de la creación del comentario.
  #
  def create_event!
    noficable_users = travel.comments_users + [travel.user] - [user]

    EventCreationJob.new.perform(
      source: user,
      resource: self,
      notify_to: noficable_users
    )
  end
end
