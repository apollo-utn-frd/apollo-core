# frozen_string_literal: true
module Searchable
  module Comment
    extend ActiveSupport::Concern
    include Searchable::Search

    included do
      scope :content_like, ->(query) { where('content ILIKE ?', "%#{query}%") }
      scope :search_token, ->(query) { content_like(query) }
    end
  end
end
