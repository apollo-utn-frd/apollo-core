# frozen_string_literal: true

module Apollo
  class UserNotAuthorized < StandardError
    attr_reader :resource, :action

    def initialize(resource = nil, action = nil)
      @resource = resource
      @action = action&.tr('_', ' ')
    end
  end
end
