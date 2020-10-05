# frozen_string_literal: true

module Error

  class BasecampError < Error; end

  class InvalidResource < Error; end

  class ResourceNotFound < BasecampError; end

  class TodoCompleted < BasecampError; end
end