# frozen_string_literal: true

class UserImageCreationJob < ImageCreationJob
  queue_as :user_images
end
