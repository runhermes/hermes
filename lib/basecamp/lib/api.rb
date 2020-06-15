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
      (Configuration::VALID_OPTIONS_KEYS + [:auth_token]).each do |key|
        send("#{key}=", options[key]) if options[key]
      end
      request_defaults(sudo)
      self.class.headers 'User-Agent' => user_agent
    end
  end
end