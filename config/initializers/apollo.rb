# frozen_string_literal: true

# Image Service
require Rails.root.join('lib', 'image_service')

# Exceptions
require Rails.root.join('lib', 'exceptions', 'user_not_authorized')

# Monkey patching
require Rails.root.join('lib', 'enumerable')
require Rails.root.join('lib', 'string')
