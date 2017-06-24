# frozen_string_literal: true
class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:posts]

  def posts
    render json: current_user.home_posts.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def root
    render json: { message: 'Welcome to Apollo API!' }
  end
end
