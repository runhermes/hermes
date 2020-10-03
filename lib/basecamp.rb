# frozen_string_literal: true

require 'uri'
require 'forwardable'

class Basecamp

  extend Forwardable

  def_delegators :@client, :authorization_uri, :authorize!

  def initialize
    @client = Camper.client
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