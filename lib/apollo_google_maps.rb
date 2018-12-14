# frozen_string_literal: true

module ApolloGoogleMaps
  module_function

  def image_url(travel)
    map = GoogleStaticMapsHelper::Map.new

    travel.places.each_with_index do |place, i|
      map << GoogleStaticMapsHelper::Marker.new(
        place,
        label: (i + 65).chr
      )
    end

    if travel.places.many?
      path = GoogleStaticMapsHelper::Path.new(color: :black)

      travel.places.each { |place| path << place }

      map << path
    end

    map.url
  end
end
