# Strategy to authenticate with Google via OAuth2 in OmniAuth.
# Get your API key at: https://code.google.com/apis/console/ Note the Client ID
# and the Client Secret.
# Note: You must enable the "Contacts API" and "Google+ API" via the Google API console.
# Otherwise, you will receive an OAuth2::Error(Error: "Invalid credentials") stating that
# access is not configured when you attempt to authenticate.
# For more details, read the Google docs: https://developers.google.com/accounts/docs/OAuth2

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  google_client_id = Rails.application.secrets.google_client_id
  google_client_secret = Rails.application.secrets.google_client_secret

  provider :google_oauth2, google_client_id, google_client_secret, {
    image_aspect_ratio: 'square'
  }
end
