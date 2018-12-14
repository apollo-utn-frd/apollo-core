# frozen_string_literal: true

class TravelsController < ApplicationController
  before_action :authenticate_user!, only: %i[
    create
    destroy
    create_comments
    create_favorites
    destroy_favorites
    new
  ]

  before_action :set_travel, except: %i[
    create
    search
    new
  ]

  before_action :only_manager_users, only: %i[destroy]

  def new
    render 'travels/new'
  end

  def show
    respond_to do |format|
      format.html { render 'travels/viewrvs' }
      format.json { render :show }
    end
  end

  def create
    @travel = nil

    ActiveRecord::Base.transaction do
      @travel = Travel.create!(create_params)
      @travel.authorize_all!(authorizations_users) unless @travel.publicx?
    end

    render :show, status: :created
  end

  def destroy
    @travel.destroy!

    head :no_content
  end

  def search
    @travels = Travel.search(search_params)

    render :index
  end

  def index_authorizations
    @authorizations = @travel.authorizations

    render 'authorizations/index'
  end

  def index_comments
    @comments = @travel.comments

    render 'comments/index'
  end

  def create_comments
    @comment = current_user.comment!(@travel, comment_params)

    respond_to do |format|
      format.html { redirect_to travel_path(@comment.travel_id) }
      format.json { render 'comments/show', status: :created }
    end
  end

  def index_favorites
    @favorites = @travel.favorites

    render 'favorites/index'
  end

  def create_favorites
    @favorite = current_user.favorite!(@travel)

    render 'favorites/show'
  end

  def destroy_favorites
    current_user.unfavorite!(@travel)

    head :no_content
  end

  private

  def set_travel
    travel_id = params[:id] || params[:travel_id]

    @travel = Travel.find(travel_id)

    unless @travel.readable?(current_user)
      raise ActiveRecord::RecordNotFound.new(nil, Travel, :id, travel_id)
    end

    @travel
  end

  def create_params
    places = params.fetch(:places).map do |plc|
      longitude = plc.fetch(:longitude)
      latitude = plc.fetch(:latitude)

      {
        title: plc.fetch(:title),
        description: plc.fetch(:description),
        coordinates: "POINT(#{longitude} #{latitude})"
      }
    end

    {
      title: params.fetch(:title),
      description: params[:description],
      publicx: params.fetch(:public, true),
      places_attributes: places,
      user: current_user
    }
  end

  def comment_params
    params.fetch(:content)
  end

  def search_params
    params.fetch(:query, '')
  end

  def authorizations_users
    params.fetch(:authorizations, []).map do |param|
      id = {
        id: param[:id],
        username: param[:username]
      }.compact

      id = Hash[*id.first]

      if id.blank?
        raise ActionController::ParameterMissing, '\'id\' or \'username\' in authorizations'
      end

      user = User.find_by(id)

      if user.blank?
        raise ActiveRecord::RecordNotFound.new(nil, User, id.keys.first, id.values.first)
      end

      user
    end
  end

  def only_manager_users
    return if @travel.manageable?(current_user)

    raise Apollo::UserNotAuthorized.new(@travel, params[:action])
  end
end
