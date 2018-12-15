# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                   :uuid             not null, primary key
#  username             :string           not null
#  email                :string           not null
#  name                 :string
#  lastname             :string
#  google_id            :string
#  gender               :string
#  image_url            :text
#  image_public_url     :text
#  thumbnail_public_url :text
#  description          :text             default(""), not null
#  confirmed            :boolean          default(FALSE), not null
#  confirmed_at         :datetime
#  extra                :jsonb            not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  uid                  :text
#  provider             :string
#  oauth_token          :text
#  oauth_refresh_token  :text
#  oauth_expires_at     :datetime
#  tokens               :json
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

  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_secure_token :uid

  include Imageable
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

  validates :username, length: { in: 4..30 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :name, length: { in: 1..30 }
  validates :lastname, length: { in: 1..30 }
  validates :google_id, presence: true, uniqueness: true
  validates :description, length: { maximum: 150 }
  validates :gender, inclusion: { in: GENDERS }, allow_blank: true

  validate :validate_username_format
  validate :validate_username_reserved

  before_validation :set_username, on: :create
  before_validation :downcase_username
  before_validation :set_confirmed_at

  after_create_commit :create_event!
  after_create_commit :download_image!

  ##
  # Devuelve un usuario dado sus datos de autenticacion. Si no existe lo crea.
  #
  def self.from_omniauth(auth)
    ApolloAuth.from_omniauth(auth)
  end

  def full_name
    "#{name} #{lastname}".squish
  end

  ##
  # Devuelve todas las publicaciones de la home de un usuario.
  #
  def home_posts
    followings_posts = followings_users.flat_map(&:posts)

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
    followings.find_or_create_by!(following_id: user.id)
  end

  ##
  # Produce que el usuario deje de seguir a otro usuario.
  #
  def unfollow!(user)
    followings.find_by(following_id: user.id)&.destroy!
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
    favorites.find_or_create_by!(travel_id: travel.id)
  end

  ##
  # Produce que el usuario deje de marcar como favorito a un viaje.
  #
  def unfavorite!(travel)
    favorites.find_by(travel_id: travel.id)&.destroy!
  end

  ##
  # Devuelve si el usuario comentó un viaje.
  #
  def comment?(travel)
    comments_travels.include?(travel)
  end

  ##
  # Produce que el usuario comente un viaje.
  #
  def comment!(travel, content)
    comments.create!(
      travel_id: travel.id,
      content: content
    )
  end

  ##
  # Devuelve si el usuario puede ser accedido por un determinado usuario.
  #
  def readable?(user)
    confirmed? || self == user
  end

  ##
  # Devuelve si el usuario puede ser gestionado por un determinado usuario.
  #
  def manageable?(user)
    self == user
  end

  ##
  # Notifica al usuario de un evento.
  #
  def notify!(event)
    notifications.find_or_create_by!(event: event)
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
    EventCreationJob.new.perform(
      source: self,
      resource: self
    )
  end

  ##
  # Descarga la imagen de perfil y ajusta la ruta de destino de la imagen.
  #
  def download_image!
    UserImageCreationJob.new.perform(self)
  end

  ##
  # Devuelve si el usuario necesita una contraseña.
  # Nota: necesario para que funcione DeviseTokenAuth.
  #
  def password_required?
    false
  end

  ##
  # Devuelve si el formato del nombre de usuario es válido.
  #
  def valid_username_format?
    /\A[a-z0-9_]+\z/.match?(username)
  end

  ##
  # Devuelve si el nombre de usuario es una palabra reservada.
  #
  def username_reserved?
    ReservedUsernames.include?(username)
  end

  ##
  # Valida el formato del nombre de usuario.
  #
  def validate_username_format
    return if valid_username_format?

    errors.add(:username, :invalid_characters)
  end

  ##
  # Valida si el nombre de usuario es una palabra reservada.
  #
  def validate_username_reserved
    return unless username_reserved?

    errors.add(:username, :exclusion)
  end

  ##
  # Genera un nombre de usuario dada una string base.
  #
  def generate_username(base)
    username = base

    suffix = 0
    while User.exists?(username: username)
      username = "#{base}#{suffix}"
      suffix += 1
    end

    username
  end

  ##
  # Asigna el nombre de usuario.
  #
  def set_username
    return if username?
    return unless email?

    base = email.partition('@').first.tr('.', '_')

    self.username = generate_username(base)
  end

  ###
  # Convierte el nombre de usuario a minusculas.
  #
  def downcase_username
    return unless username_changed?

    self.username = username.downcase
  end

  ##
  # Asigna la fecha de confirmación del usuario.
  #
  def set_confirmed_at
    return unless confirmed? && !confirmed_at?

    self.confirmed_at = Time.current
  end
end
