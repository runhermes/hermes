# frozen_string_literal: true

module Basecamp
  # Defines constants and methods related to configuration.
  module Configuration
    # An array of valid keys in the options hash when configuring a Basecamp::API.
    VALID_OPTIONS_KEYS = %i[client_id client_secret redirect_uri refresh_token access_token].freeze

    # The user agent that will be sent to the API endpoint if none is set.
    DEFAULT_USER_AGENT = "Basecamp library"

    # @private
    attr_accessor(*VALID_OPTIONS_KEYS)

    # Sets all configuration options to their default values
    # when this module is extended.
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block.
    def configure
      yield self
    end

    # Creates a hash of options and their values.
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Resets all configuration options to the defaults.
    def reset
      self.client_id      = ENV['BASECAMP_CLIENT_ID']
      self.client_secret  = ENV['BASECAMP_CLIENT_SECRET']
      self.redirect_uri   = ENV['BASECAMP_REDIRECT_URI']
      self.refresh_token  = ENV['BASECAMP_REFRESH_TOKEN']
      self.access_token   = ENV['BASECAMP_ACCESS_TOKEN']
      self.user_agent     = DEFAULT_USER_AGENT
    end

    def auth_endpoint
      'https://launchpad.37signals.com/authorization/new'
    end

    def token_endpoint
      'https://launchpad.37signals.com/authorization/token'
    end

    def api_endpoint
      'https://3.basecampapi.com'
    end
  end
end