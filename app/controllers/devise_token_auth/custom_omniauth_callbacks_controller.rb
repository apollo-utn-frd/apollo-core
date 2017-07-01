# frozen_string_literal: true

module DeviseTokenAuth
  class CustomOmniauthCallbacksController < OmniauthCallbacksController
    private

    def resource_class(_mapping = nil)
      User
    end

    def get_resource_from_auth_hash
      @resource = User.from_omniauth(request.env['omniauth.auth'])
    end
  end
end
