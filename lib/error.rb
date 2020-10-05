# frozen_string_literal: true

module Error

  # Custom error class for rescuing from all basecamp errors.
  class BasecampError < StandardError
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end
  end

  class InvalidResource < BasecampError
  end

  class ResourceNotFound < BasecampError; end

  class TodoCompleted < BasecampError; end
end