# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[posts]

  def posts
    @events = current_user.home_posts

    render 'events/index'
  end

  def root
    render '/root'
  end
end
