# frozen_string_literal: true

class TravelImageCreationJob < ImageCreationJob
  queue_as :travel_images
end
