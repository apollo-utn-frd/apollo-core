# frozen_string_literal: true

notifications = @notifications.paginate(
  page: params[:page],
  per_page: params[:per_page]
)

json.partial! 'notifications/notification', collection: notifications, as: :notification
