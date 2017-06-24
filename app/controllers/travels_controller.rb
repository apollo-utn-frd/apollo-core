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
    render json: @travel
  end

  def create
    travel = nil

    ActiveRecord::Base.transaction do
      travel = Travel.create!(create_params)
      travel.authorize_all!(authorizations_users) unless travel.publicx?
    end

    render json: travel
  end

  def destroy
    unless @travel.deleteable?(current_user)
      raise Apollo::UserNotAuthorized.new(@travel, :destroy)
    end

    @travel.destroy!

    head :no_content
  end

  def search
    query = params.fetch(:query, '')
    search = Travel.search(query)

    render json: search.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def image
    send_file "public/travels/#{@travel.picture_local_path}",
              type: 'image/jpeg',
              disposition: 'inline'
  end

  def create_comment
    render json: Comment.create!(comment_params)
  end

  def create_favorite
    render json: current_user.favorite!(@travel)
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
    # TODO: esto funciona?
    # places = params.require(places: %i[latitude longitude])
    places = params.require(:places).map do |plc|
      plc.require(:latitude, :longitude)
    end

    {
      title: params.require(:title),
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
      content: params.require(:content)
    }
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
