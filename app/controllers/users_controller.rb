# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[
    update
    update_image
    index_authorizations
    create_followers
    destroy_followers
  ]

  before_action :set_user, except: %i[search]

  before_action :only_manager_users, only: %i[
    update
    update_image
    index_authorizations
  ]

  def show
    render :show
  end

  def update
    @user.update!(update_params)

    render :show
  end

  def search
    @users = User.search(search_params)

    render :index
  end

  def show_image
    send_file "public/users/#{@user.picture_local_path}",
              type: 'image/jpeg',
              disposition: 'inline'
  end

  # TODO
  def update_image; end

  def index_travels
    @travels = @user.travels

    render '/travels/index'
  end

  def index_authorizations
    @authorizations = @user.authorizations

    render '/authorizations/index'
  end

  def index_favorites
    @favorites = @user.favorites

    render '/favorites/index'
  end

  def index_followings
    @followings = @user.followings

    render '/followings/index'
  end

  def index_followers
    @followings = @user.followers

    render '/followings/index'
  end

  def create_followers
    @following = current_user.follow!(@user)

    render '/followings/show'
  end

  def destroy_followers
    current_user.unfollow!(@user)

    head :no_content
  end

  def index_posts
    @events = @user.posts

    render '/events/index'
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

  def only_manager_users
    return if @user.manageable?(current_user)

    action = params[:action].tr('_', ' ')
    raise Apollo::UserNotAuthorized.new(@user, action)
  end
end
