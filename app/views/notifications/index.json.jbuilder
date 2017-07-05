# frozen_string_literal: true

notifications = @notifications.readables(current_user).paginate(params)

json.partial! 'notifications/notification', collection: notifications, as: :notification
