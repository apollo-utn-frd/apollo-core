# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :following, :unfollowing]
  before_action :set_user, except: [:search]

  def show
    render :show
  end

  def update
    unless @user.manageable?(current_user)
      raise Apollo::UserNotAuthorized.new(@user, :update)
    end

    @user.update!(update_params)

    render :show
  end

  def search
    @users = User.search(search_params)

    render :index
  end

  def index_posts
    @events = @user.posts

    render '/events/index'
  end

  def show_image
    send_file "public/users/#{@user.picture_local_path}",
              type: 'image/jpeg',
              disposition: 'inline'
  end

  def create_follower
    @following = current_user.follow!(@user)

    render '/following/show'
  end

  def destroy_follower
    current_user.unfollow!(@user)

    head :no_content
  end

  private

  def set_user
    user_id = params[:id] || params[:user_id]

    if user_id == 'me' && user_signed_in?
      @user = current_user
    else
      @user = User.find_by(username: user_id) || User.find(user_id)
    end

    unless @user.readable?(current_user)
      raise ActiveRecord::RecordNotFound.new(nil, User, :id, user_id)
    end

    @user
  end

  def update_params
    update_params = params.permit(
      :name,
      :lastname,
      :description
    )

    unless @user.confirmed?
      update_params[:username] = params[:username] if params.include?(:username)
      update_params[:confirmed] = true
    end

    update_params
  end

  def search_params
    params.fetch(:query, '')
  end
end
