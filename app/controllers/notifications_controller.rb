# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.where(index_params)

    render :index
  end

  def read
    @notifications = current_user.notifications.not_readed.map(&:read!)

    render :index
  end

  private

  def index_params
    {
      readed: ActiveModel::Type::Boolean.new.cast(params[:readed])
    }.compact
  end
end
