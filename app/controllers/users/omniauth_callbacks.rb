# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren:

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env['omniauth.auth'])

    if user.enabled?
      session[:user_id] = user.id
      redirect_to home_path
    else
      redirect_to root_path
    end
  end
end
