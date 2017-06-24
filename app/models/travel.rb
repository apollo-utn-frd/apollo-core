# frozen_string_literal: true
# == Schema Information
#
# Table name: travels
#
#  id                 :uuid             not null, primary key
#  title              :string           not null
#  description        :text             default(""), not null
#  picture_local_path :text
#  publicx            :boolean          default(TRUE), not null
#  user_id            :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#

class Travel < ApplicationRecord
  include Searchable::Travel

  belongs_to :user

  has_one :event, as: :resource, dependent: :destroy

  has_many :authorizations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :places, inverse_of: :travel, dependent: :destroy

  has_many :authorizations_users, through: :authorizations, source: :user
  has_many :comments_users, through: :comments, source: :user
  has_many :favorites_users, through: :favorites, source: :user

  validates :title, length: { in: 2..30 }, presence: true
  validates :description, length: { in: 0..1000 }
  validates :places, length: { in: 1..25, message: 'must be between 1 and 25' }

  after_create_commit :create_event!
  after_create_commit :download_picture!

  accepts_nested_attributes_for :places

  scope :privatex, -> { where(publicx: false) }
  scope :publicx, -> { where(publicx: true) }

  ##
  # Devuelve si el viaje puede ser accedido por un determinado usuario.
  #
  def readable?(user)
    publicx || user == self.user || authorizations_users.include?(user)
  end

  ##
  # Devuelve si el viaje puede ser eliminado por un determinado usuario.
  #
  def deleteable?(user)
    user == self.user
  end

  ##
  # Autoriza a un usuario a acceder al viaje.
  #
  def authorize!(user)
    authorizations.find_or_create_by!(user: user)
  end

  ##
  # Autoriza a una lista de usuarios a acceder al viaje.
  #
  def authorize_all!(users)
    Array(users).map { |user| authorize!(user) }
  end

  ##
  # Devuelve la URL de la imagen de previsualización de un viaje dado.
  #
  def picture_url
    map = GoogleStaticMapsHelper::Map.new

    places.each_with_index do |place, i|
      map << GoogleStaticMapsHelper::Marker.new(
        place,
        label: (i + 65).chr
      )
    end

    if places.many?
      path = GoogleStaticMapsHelper::Path.new(color: :black)

      places.each { |place| path << place }

      map << path
    end

    map.url
  end

  private

  ##
  # Crea el evento de la creación del viaje.
  #
  def create_event!
    CreationEventJob.perform_later(
      source: user,
      resource: self
    )
  end

  ##
  # Descarga la imagen de previsualización y ajusta la ruta de destino de la imagen.
  #
  def download_picture!
    SetPictureJob.perform_later(self)
  end
end
