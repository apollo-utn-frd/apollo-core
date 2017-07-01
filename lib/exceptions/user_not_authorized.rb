# frozen_string_literal: true

module Apollo
  class UserNotAuthorized < StandardError
    attr_reader :resource, :action

    def initialize(resource, action)
      @resource = resource
      @action = action
    end
  end
end
