# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :uuid             not null, primary key
#  username            :string           not null
#  email               :string           not null
#  name                :string           not null
#  lastname            :string           not null
#  google_id           :string           not null
#  gender              :string           not null
#  picture_url         :text             not null
#  picture_local_path  :text
#  description         :text             default(""), not null
#  confirmed           :boolean          default(FALSE), not null
#  confirmed_at        :datetime
#  extra               :jsonb            not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  uid                 :text
#  provider            :string
#  oauth_token         :text
#  oauth_refresh_token :text
#  oauth_expires_at    :datetime
#  tokens              :json
#
# Indexes
#
#  index_users_on_email                   (email)
#  index_users_on_google_id_and_provider  (google_id,provider) UNIQUE
#  index_users_on_uid                     (uid) UNIQUE
#  index_users_on_username                (username)
#

class User < ApplicationRecord
  GENDERS = %w[
    male
    female
    other
  ].freeze

  devise :omniauthable

  include DeviseTokenAuth::Concerns::User
  include Searchable::User

  has_one :event, as: :resource, dependent: :destroy

  has_many :authorizations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :travels, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :followers, class_name: Following.name, foreign_key: :following_id, dependent: :destroy
  has_many :followings, class_name: Following.name, foreign_key: :follower_id, dependent: :destroy

  has_many :authorizations_travels, through: :authorizations, source: :travel
  has_many :comments_travels, through: :comments, source: :travel
  has_many :favorites_travels, through: :favorites, source: :travel
  has_many :followers_users, through: :followers, source: :follower
  has_many :followings_users, through: :followings, source: :following

  validates :username, length: { in: 4..30 }, presence: true, uniqueness: true
  validates :username, format: {
    with: /\A\w+\z/,
    message: 'can contain numbers, letters and underscore only'
  }
  validates :email, presence: true, uniqueness: true
  validates :name, length: { in: 1..30 }, presence: true
  validates :lastname, length: { in: 1..30 }, presence: true
  validates :google_id, presence: true, uniqueness: true
  validates :description, length: { maximum: 150 }
  validates :gender, inclusion: { in: GENDERS }

  before_validation :set_username, on: :create
  before_validation :set_confirmed_at

  after_create :set_uid!

  after_create_commit :create_event!
  after_create_commit :download_picture!

  scope :confirmed, -> { where(confirmed: true) }

  def self.from_omniauth(auth)
    where(provider: auth.provider, google_id: auth.uid).first_or_initialize.tap do |user|
      if user.new_record?
        user.name = auth.info.first_name
        user.lastname = auth.info.last_name
      end

      user.email = auth.info.email
      user.picture_url = auth.info.image
      user.gender = auth.extra.raw_info.gender
      user.extra = [auth.info.slice(:urls)]
      user.oauth_token = auth.credentials.token
      user.oauth_refresh_token = auth.credentials.refresh_token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at).utc

      user.save!
    end
  end

  ##
  # Devuelve todas las publicaciones de la home de un usuario.
  #
  def home_posts
    followings_posts = followings_users.flat_map(&:posts).select do |post|
      post.readable?(self)
    end

    posts.to_a.concat(followings_posts).sort_by(&:created_at).reverse
  end

  ##
  # Devuelve todas las publicaciones del perfil de un usuario.
  #
  def posts
    Event.source(self).posts.order(created_at: :desc)
  end

  ##
  # Devuelve si el usuario sigue a otro usuario.
  #
  def follow?(user)
    followings_users.include?(user)
  end

  ##
  # Produce que el usuario siga a otro usuario.
  #
  def follow!(user)
    followings.find_or_create_by!(following: user)
  end

  ##
  # Produce que el usuario deje de seguir a otro usuario.
  #
  def unfollow!(user)
    followings.find_by(user: user).try(&:destroy!)
  end

  ##
  # Devuelve si el usuario marcó como favorito a un viaje.
  #
  def favorite?(travel)
    favorites_travels.include?(travel)
  end

  ##
  # Produce que el usuario marque como favorito a un viaje.
  #
  def favorite!(travel)
    favorites.find_or_create_by!(travel: travel)
  end

  ##
  # Produce que el usuario deje de marcar como favorito a un viaje.
  #
  def unfavorite!(travel)
    favorites.find_by(travel: travel).try(&:destroy!)
  end

  ##
  # Devuelve si los datos del usuario pueden ser accedidos por un determinado usuario.
  #
  def readable?(_user)
    true
  end

  ##
  # Devuelve si los datos privados del usuario pueden ser accedidos por un determinado usuario.
  #
  def manageable?(user)
    self == user
  end

  ##
  # Devuelve al usuario habiéndole eliminado todas las referencias a viajes privados
  # que un usuario dado como parámetro no puede acceder.
  #
  # TODO
  def sanitize(_user)
    # self.travels = self.travels.select { |travel| travel.readable?(user) }
    # self.favorites = self.favorites.select { |favorite| favorite.readable?(user) }
    # self.comments = self.comments.select { |comment| comment.readable?(user) }

    self
  end

  ##
  # Notifica al usuario de un evento.
  #
  def notify!(event)
    notifications.create!(event: event)
  end

  ##
  # Devuelve si el usuario fue confirmado.
  # Nota: sobreescribe el método 'confirmed?' de DeviseTokenAuth::Concerns::User.
  #
  def confirmed?
    confirmed
  end

  private

  ##
  # Crea el evento de la creación del usuario.
  #
  def create_event!
    CreationEventJob.perform_later(
      source: self,
      resource: self
    )
  end

  ##
  # Descarga la imagen de perfil y ajusta la ruta de destino de la imagen.
  #
  def download_picture!
    SetPictureJob.perform_later(self)
  end

  ##
  # Devuelve si el usuario necesita una contraseña.
  # Nota: necesario para que funcione DeviseTokenAuth.
  #
  def password_required?
    false
  end

  ##
  # Asigna el uid al usuario.
  #
  def set_uid!
    return if self.uid.present?

    update!(uid: format_id)
  end

  ##
  # Asigna el username al usuario si no tiene uno.
  #
  def set_username
    return if self.username.present?

    base = self.email.partition('@').first.tr('.', '_')

    self.username = generate_username(base)
  end

  ##
  # Genera un username dada un username base.
  #
  def generate_username(base)
    username = base

    i = 0
    while User.exists?(username: username)
      username = "#{base}#{i}"
      i += 1
    end

    username
  end

  ##
  # Asigna la fecha de confirmación del usuario.
  #
  def set_confirmed_at
    return unless confirmed? && confirmed_at.blank?

    self.confirmed_at = Time.current
  end
end
