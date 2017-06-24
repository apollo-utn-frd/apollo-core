# frozen_string_literal: true

# Monkey patch
require Rails.root.join('lib', 'google_static_maps', 'google_static_maps_helper')
require Rails.root.join('lib', 'google_static_maps', 'maps')

GoogleStaticMapsHelper.size = '640x400'
GoogleStaticMapsHelper.language = 'es'
GoogleStaticMapsHelper.region = 'ar'
GoogleStaticMapsHelper.key = Rails.application.secrets.google_static_maps_key
