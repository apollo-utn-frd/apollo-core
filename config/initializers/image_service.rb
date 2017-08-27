# frozen_string_literal: true

require Rails.root.join('lib', 'image_service')

ImageService.format = 'png'
ImageService.cloudinary_url = ENV['APOLLO_CLOUDINARY_URL']
