# frozen_string_literal: true

module GoogleStaticMapsHelper
  class Map
    remove_const :REQUIRED_OPTIONS
    const_set :REQUIRED_OPTIONS, %w[
      size
      key
    ]

    remove_const :OPTIONAL_OPTIONS
    const_set :OPTIONAL_OPTIONS, %w[
      center
      zoom
      maptype
      format
      mobile
      language
      region
      sensor
    ]

    attr_accessor :key, :region
  end
end
