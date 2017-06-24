# frozen_string_literal: true
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    notifications = current_user.notifications.where(index_params)

    render json: notifications.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def read
    notifications = current_user.notifications.where(readed: false)

    render json: notifications.map(&:read!).paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  private

  def index_params
    {
      readed: ActiveModel::Type::Boolean.new.cast(params[:readed])
    }.compact
  end
end
