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
      format.html { render 'travels/show.html' }
      format.json { render :show }
    end
  end

  def create
    @travel = nil

    ActiveRecord::Base.transaction do
      @travel = Travel.create!(create_params)
      @travel.authorize_all!(authorizations_users) unless @travel.publicx?
    end

    respond_to do |format|
      format.html { redirect_to travel_path(@travel.format_id) }
      format.json { render 'travels/show.json', status: :created }
    end
  end

  def destroy
    @travel.destroy!

    respond_to do |format|
      format.html do
        flash[:icon] = 'fas fa-fw fa-map-marker-alt'
        flash[:success] = 'El viaje fue eliminado correctamente.'
        redirect_to home_path
      end

      format.json do
        head :no_content
      end
    end
  end

  def search
    @travels = Travel.search(search_params).order(created_at: :desc)

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

    respond_to do |format|
      format.html do
        redirect_back fallback_location: travel_path(@travel.format_id)
      end

      format.json do
        render '/favorites/show'
      end
    end
  end

  def destroy_favorites
    current_user.unfavorite!(@travel)

    respond_to do |format|
      format.html do
        redirect_back fallback_location: travel_path(@travel.format_id)
      end

      format.json do
        head :no_content
      end
    end
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
    User.where(id: params.fetch(:authorizations, []))
  end

  def only_manager_users
    return if @travel.manageable?(current_user)

    raise Apollo::UserNotAuthorized.new(@travel, params[:action])
  end
end
