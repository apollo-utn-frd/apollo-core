# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])

    if user.enabled?
      session[:user_id] = user.id
      redirect_to home_path
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
