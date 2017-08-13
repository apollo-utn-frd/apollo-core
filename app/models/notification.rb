# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id         :uuid             not null, primary key
#  readed     :boolean          default(FALSE), not null
#  readed_at  :datetime
#  user_id    :uuid             not null
#  event_id   :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }

  before_validation :set_readed_at

  scope :readed, -> { where(readed: true) }
  scope :not_readed, -> { where(readed: false) }

  ##
  # Marca como leída la notificación.
  #
  def read!
    update!(readed: true)

    self
  end

  ##
  # Devuelve si la notificación puede ser accedida por un determinado usuario.
  #
  def readable?(user)
    user == self.user
  end

  private

  def set_readed_at
    return unless readed? && readed_at.blank?

    self.readed_at = Time.current
  end
end
