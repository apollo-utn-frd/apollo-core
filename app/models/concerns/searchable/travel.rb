# frozen_string_literal: true
module Searchable
  module Travel
    extend ActiveSupport::Concern
    include Searchable::Search

    included do
      scope :title_like, ->(query) { where('title ILIKE ?', "%#{query}%") }
      scope :description_like, ->(query) { where('description ILIKE ?', "%#{query}%") }
      scope :search_token, ->(query) { title_like(query).or(description_like(query)) }
    end
  end
end
