# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :following, :unfollowing]
  before_action :set_user, except: [:search, :username]
  before_action :set_user_by_username, only: :username

  def show
    render json: @user.sanitize(current_user)
  end

  def update
    unless @user == current_user
      raise Apollo::UserNotAuthorized.new(@user, :update)
    end

    current_user.update!(update_params)

    render json: current_user
  end

  def posts
    render json: @user.posts.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def username
    render json: @user.sanitize(current_user)
  end

  def search
    query = params.fetch(:query, '')
    search = User.search(query)

    render json: search.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def image
    send_file "public/users/#{@user.picture_local_path}",
              type: 'image/jpeg',
              disposition: 'inline'
  end

  def create_follower
    render json: current_user.follow!(@user)
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
      @user = User.find(user_id)
    end
  end

  def set_user_by_username
    user_username = params[:username]

    @user = User.find_by(username: user_username)

    unless @user
      raise ActiveRecord::RecordNotFound.new(nil, User, :username, user_username)
    end

    @user
  end

  def update_params
    update_params = params.permit(
      :name,
      :lastname,
      :description
    )

    unless current_user.confirmed?
      update_params[:username] = params[:username] if params.include?(:username)
      update_params[:confirmed] = true
    end

    update_params
  end
end
