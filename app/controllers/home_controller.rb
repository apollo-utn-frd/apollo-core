# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[posts home]

  def posts
    @events = current_user.home_posts

    render 'events/index'
  end

  def home
    @user = current_user
    @posts = @user.home_posts
  end

  def root
    if current_user
      redirect_to home_path
    else
      render 'root/root'
    end
  end
end
