# frozen_string_literal: true

module Error

  # Custom error class for rescuing from all Camper errors.
  class BasecampError < StandardError; end

  class InvalidResource < BasecampError; end

  class ResourceNotFound < BasecampError; end

  class TodoCompleted < BasecampError; end
end