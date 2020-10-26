# frozen_string_literal: true

require 'uri'
require 'forwardable'

class Basecamp

  extend Forwardable

  def_delegators :@client, :authorization_uri

  attr_accessor :request

  def initialize(logger)
    @logger = logger
    @client = Camper.client
  end

  def authorize!(code)
    @logger.info "Fetching OAuth tokens from Basecamp using code: #{code}"
    token = @client.authorize! code

    @logger.info "Refresh token: #{token.refresh_token}"
    @logger.info "Access token: #{token.access_token}"
    token
  end

  def resources
    links = find_links(@request["object_attributes"]["description"])

    resources = links.map { |link| @client.resource(link) }
  end

  def update_comments(resource, repo_client)
    case repo_client.state
    when PullRequestState::OPENED
      @logger.info "Creating comment for opened #{repo_client.acronym} ##{repo_client.id}"
      result = @client.create_comment(resource, open_request_comment(repo_client))
      @logger.info "Result: #{result}"
    when PullRequestState::MERGED
    end
  end

  private

  def open_request_comment(repo_client)
    "This TODO will be completed once #{repo_client.acronym} #{repo_client.url} is merged"
  end

  def find_links(text)
    links = URI.extract(text)

    links.select { |link| link.start_with?('https://3.basecamp.com') }
  end
end