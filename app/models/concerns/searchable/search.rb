# frozen_string_literal: true

module Searchable
  module Search
    extend ActiveSupport::Concern

    included do
      scope :search, ->(query) {
        sanitized_query = query.strip
        sanitized_query.size > 1 ? search_query(sanitized_query) : none
      }

      scope :search_query, ->(query) {
        query.split.reduce(all) do |chain, token|
          chain.merge(search_token(token))
        end
      }
    end
  end
end
