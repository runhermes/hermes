# frozen_string_literal: true

require 'uri'
require 'forwardable'

class Basecamp

  extend Forwardable

  def_delegators :@client, :authorization_uri

  def initialize
    @client = Camper.client
  end

  def authorize!(code)
    logger.info 'Fetching OAuth tokens from Basecamp'
    token = @client.authorize! auth_code

    puts "Refresh token: #{token.refresh_token}"
    puts "Access token: #{token.access_token}"
    token
  end

  def find_links(text)
    links = URI.extract(text)

    links.select { |link| link.start_with?('https://3.basecamp.com') }
  end

  def resources(text)
    links = find_links(text)

    resources = links.map { |link| @client.resource(link) }
  end
end