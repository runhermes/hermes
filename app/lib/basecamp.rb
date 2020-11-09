# frozen_string_literal: true

require 'uri'
require 'forwardable'

class Basecamp

  extend Forwardable

  def_delegators :@client, :authorization_uri

  attr_accessor :request

  def initialize(logger)
    @logger = logger
    @client = Camper.configure do |config|
      config.client_id = Settings.basecamp.client_id
      config.client_secret = Settings.basecamp.client_secret
      config.account_number = Settings.basecamp.account_number
      config.refresh_token = Settings.basecamp.refresh_token
      config.access_token = Settings.basecamp.access_token
    end
  end

  def authorize!(code)
    @logger.info "Fetching OAuth tokens from Basecamp using code: #{code}"
    @client.authorize! code
  end

  def resources
    links = find_links(@request.description)

    resources = links.map { |link| @client.resource(link) }
  end

  def apply_todo_workflow(resource, pull_request)
    current_user_comments = comments_by_current_user(resource)
    tags = pull_request.tags + ["Status:#{pull_request.state}"]

    # Prevent multiple comments without action change
    if !skip_comment_checks?(pull_request.action) && current_user_comments.any? { |c| match_tags(c, tags) }
      @logger.info "Comment already created on #{resource.type}##{resource.id}"
      return
    end

    tags << info_colour(pull_request.state)
    message = nil

    case pull_request.action
    when PullRequestAction::OPEN, PullRequestAction::UPDATE
      if resource.completed
        @logger.info "To-do was already completed. Add linking comment"
        message = linking_comment(pull_request, tags)
      else
        @logger.info "Creating opening comment for #{pull_request.full_name}"
        message = opening_comment(pull_request, tags)
      end
    when PullRequestAction::CLOSE
      @logger.info "Closing comment for #{pull_request.full_name}"
      message = closed_comment(pull_request, tags)
    when PullRequestAction::REOPEN
      @logger.info "Reopen item #{pull_request.full_name}"
      message = reopen_comment(pull_request, tags)
    when PullRequestAction::MERGE
      if !resource.completed
        @logger.info "Complete the To-do #{resource.app_url}."
        result = @client.complete_todo(resource)
        @logger.info "Result: #{result}"
      else
        @logger.info "To-do was already completed. No further action"
        return
      end
    else
      @logger.info "Non supported action: #{pull_request.action}"
      return
    end

    unless message.nil?
      @logger.info "Comment:\n#{message}"
      result = @client.create_comment(resource, message)
      @logger.info "Result: #{result}"
    end
  end

  def skip_comment_checks?(action)
    [PullRequestAction::CLOSE, PullRequestAction::REOPEN].include?(action)
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

  def find_links(text)
    links = URI.extract(text)

    links.select { |link| link.start_with?('https://3.basecamp.com') }
  end

  def opening_comment(pull_request, tags)
    project_tag, pr_tag, status_tag, colour = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      To-do will be completed once #{pull_request_link(pull_request)} is merged
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
      #{pull_request_link(pull_request)} was closed
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
      #{pull_request_link(pull_request)} was reopened.
      To-do will be completed once merged.
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(#{colour});">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def completing_comment(pull_request, tags)
    project_tag, pr_tag, status_tag = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      To-do is completed as #{pull_request_link(pull_request)} has been merged
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(17, 138, 15);">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(17, 138, 15);">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(17, 138, 15);">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def linking_comment(pull_request, tags)
    project_tag, pr_tag, status_tag, colour = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      #{pull_request_link(pull_request)} referenced this To-do.
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(#{colour});">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(#{colour});">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def pull_request_link(pull_request)
    "<a href='#{pull_request.url}'>#{pull_request.full_name}</a>"
  end

end