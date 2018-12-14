# frozen_string_literal: true

module ApolloAuth
  module_function

  def from_omniauth(auth)
    User.find_or_initialize_by(provider: auth.provider, email: auth.info.email).tap do |user|
      if user.new_record?
        user.name = auth.info.first_name
        user.lastname = auth.info.last_name
        user.image_url = auth.info.image
        user.google_id = auth.uid
      end

      user.gender = auth.extra.raw_info.gender
      user.extra = [auth.info.slice(:urls)]
      user.oauth_token = auth.credentials.token
      user.oauth_refresh_token = auth.credentials.refresh_token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at).utc

      user.save!
    end
  end
end
