# frozen_string_literal: true

require 'rack/oauth2'
require 'httparty'
require 'singleton'

require_relative 'lib/objectified_hash.rb'
require_relative 'lib/configuration.rb'
require_relative 'lib/error.rb'
require_relative 'lib/page_links.rb'
require_relative 'lib/paginated_response.rb'
require_relative 'lib/request.rb'
require_relative 'lib/client.rb'

module Basecamp
  extend Configuration

  # Alias for Basecamp::Client.new
  #
  # @return [Basecamp::Client]
  def self.client(options = {})
      Basecamp::Client.new(options)
  end

  # Delegate to Basecamp::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)

    client.send(method, *args, &block)
  end

  # Delegate to Basecamp::Client
  def self.respond_to_missing?(method_name, include_private = false)
    client.respond_to?(method_name) || super
  end

end