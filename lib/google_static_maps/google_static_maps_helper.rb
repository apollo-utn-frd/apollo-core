# frozen_string_literal: true

module GoogleStaticMapsHelper
  remove_const :API_URL
  const_set :API_URL, 'https://maps.googleapis.com/maps/api/staticmap'

  mattr_accessor :key, :language, :region
end
