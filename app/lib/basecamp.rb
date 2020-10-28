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
    links = find_links(@request.description)

    resources = links.map { |link| @client.resource(link) }
  end

  def apply_todo_workflow(resource, pull_request)
    current_user_comments = comments_by_current_user(resource)
    tags = pull_request.tags + ["Status:#{pull_request.state}", info_colour(pull_request.state)]

    # Prevent multiple comments without state change
    if pull_request.status == PullRequestStatus::UPDATED && current_user_comments.any? { |c| match_tags(c, tags) }
      @logger.info "Comment already created on #{resource.type}##{resource.id}"
      return
    end

    case pull_request.status
    when PullRequestStatus::OPENED, PullRequestStatus::UPDATED
      @logger.info "Creating opening comment for #{pull_request.full_name}"
      message = opening_comment(pull_request, tags)
      @logger.info "Comment:\n#{message}"
    when PullRequestStatus::CLOSED
      @logger.info "Closing comment for #{pull_request.full_name}"
      message = closed_comment(pull_request, tags)
      @logger.info "Comment:\n#{message}"
    when PullRequestStatus::REOPENED
      @logger.info "Reopen item #{pull_request.full_name}"
      message = reopen_comment(pull_request, tags)
      @logger.info "Comment:\n#{message}"
     when PullRequestStatus::MERGED
      if !resource.completed
        @logger.info "Complete the TODO of #{resource.app_url}."
        result = @client.complete_todo(resource)
        @logger.info "Result: #{result}"
      else
        @logger.info "TODO was already completed. No further action"
        return
      end

      @logger.info "Completing comment for #{pull_request.full_name}"
      message = completing_comment(pull_request,tags)
      @logger.info "Comment:\n#{message}"
    else
      @logger.info "Non supported status: #{pull_request.status}"
      return
    end
    
    result = @client.create_comment(resource, message)
    @logger.info "Result: #{result}"
  end

  def comments_by_current_user(resource)
    current_user = @client.profile

    @client.comments(resource).auto_paginate.
      select { |c| c.creator.id == current_user.id }
  end

  private

  def match_tags(comment, tags)
    tags.each do |tag|
      return false unless comment.content.match?(/<strong.*>.*#{tag}.*<\/strong>/)
    end

    true
  end

  def info_colour(state)
    state == "Opened" || state == "Merged" ? "17, 138, 15" : "138, 15, 17"
  end

  def opening_comment(pull_request, tags)
    project_tag, pr_tag, status_tag, colour = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      TODO will be completed once <a href='#{pull_request.url}'>#{pull_request.full_name}</a> is merged
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(#{colour});">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def closed_comment(pull_request, tags)
    project_tag, pr_tag, status_tag, colour = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      <a href='#{pull_request.url}'>#{pull_request.full_name}</a> was closed
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(#{colour});">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def reopen_comment(pull_request, tags)
    project_tag, pr_tag, status_tag, colour = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      <a href='#{pull_request.url}'>#{pull_request.full_name}</a> was reopened.
      TODO will be completed once merged.
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(#{colour});">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def find_links(text)
    links = URI.extract(text)

    links.select { |link| link.start_with?('https://3.basecamp.com') }
  end

  def completing_comment(pull_request, tags)
    project_tag, pr_tag, status_tag = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      This TODO is completed as <a href='#{pull_request.url}'>#{pull_request.full_name}</a> has been merged
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(17, 138, 15);">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(17, 138, 15);">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(17, 138, 15);">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

end