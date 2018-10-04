# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[posts home]

  def posts
    @events = current_user.home_posts

    render 'events/index'
  end

  def home
    @user = User.first
    @posts = User.first.home_posts
  end

  def root
    render 'root/root'
  end
end
