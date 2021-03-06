# frozen_string_literal: true

module Searchable
  module User
    extend ActiveSupport::Concern
    include Searchable::Search

    included do
      scope :confirmed, ->(confirmed) { where(confirmed: confirmed) }

      scope :username_like, ->(query) { where('username ILIKE ?', "%#{query}%") }
      scope :name_like, ->(query) { where('name ILIKE ?', "%#{query}%") }
      scope :lastname_like, ->(query) { where('lastname ILIKE ?', "%#{query}%") }

      scope :search_token, ->(query) {
        username_like(query)
          .or(name_like(query))
          .or(lastname_like(query))
      }
    end
  end
end
