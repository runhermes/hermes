# frozen_string_literal: true

module Basecamp
  # @private
  class API < Request
    # @private
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    # Creates a new API.
    # @raise [Error:MissingCredentials]
    def initialize(options = {})
      options = Basecamp.options.merge(options)
      (Configuration::VALID_OPTIONS_KEYS).each do |key|
        send("#{key}=", options[key]) if options[key]
      end
    end
  end
end