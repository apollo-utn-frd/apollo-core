# frozen_string_literal: true

class TravelsController < ApplicationController
  before_action :authenticate_user!, only: [
    :create,
    :delete,
    :comment,
    :favorite,
    :unfavorite
  ]

  before_action :set_travel, except: [:create, :search]

  def show
    render :show
  end

  def create
    @travel = nil

    ActiveRecord::Base.transaction do
      @travel = Travel.create!(create_params)
      @travel.authorize_all!(authorizations_users) unless @travel.publicx?
    end

    render :show
  end

  def destroy
    unless @travel.deleteable?(current_user)
      raise Apollo::UserNotAuthorized.new(@travel, :destroy)
    end

    @travel.destroy!

    head :no_content
  end

  def search
    @travels = Travel.search(search_params)

    render :index
  end

  def show_image
    send_file "public/travels/#{@travel.picture_local_path}",
              type: 'image/jpeg',
              disposition: 'inline'
  end

  def create_comment
    @comment = Comment.create!(comment_params)

    render 'comments/show'
  end

  def create_favorite
    @favorite = current_user.favorite!(@travel)

    render 'favorites/show'
  end

  def destroy_favorite
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
        lonlat: "POINT(#{longitude} #{latitude})"
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
    {
      user: current_user,
      travel: @travel,
      content: params.fetch(:content)
    }
  end

  def search_params
    params.fetch(:query, '')
  end

  def authorizations_users
    ids = params.fetch(:authorizations, []).map do |param|
      param[:id]
    end

    if ids.any?(&:blank?)
      raise ActionController::ParameterMissing, '\'id\' in authorizations'
    end

    User.find(ids.compact)
  end
end
