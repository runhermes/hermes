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
    case pull_request.status
    when PullRequestStatus::OPENED, PullRequestStatus::UPDATED
      tags = pull_request.tags + ['Status:Open']
      if current_user_comments.any? { |c| match_tags(c, tags) }
        @logger.info "Opening comment already created on #{resource.type}##{resource.id}"
      else
        @logger.info "Creating opening comment for #{pull_request.full_name}"
        message = opening_comment(pull_request, tags)
        @logger.info "Comment:\n#{message}"
        result = @client.create_comment(resource, message)
        @logger.info "Result: #{result}"
      end
    else
      @logger.info "Non supported status: #{pull_request.status}"
    end
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

  def opening_comment(pull_request, tags)
    project_tag, pr_tag, status_tag = tags
    @logger.info "Project Tag: #{project_tag}; PR Tag: #{pr_tag}; Status Tag: #{status_tag}"
    %{
      <div>
      TODO will be completed once <a href='#{pull_request.url}'>#{pull_request.full_name}</a> is merged
      <br><br>
      </div>
      <div>
        <strong style="color: rgb(17, 138, 15);">&lt;#{project_tag}&gt;</strong>
        <strong style="color: rgb(17, 138, 15);">&lt;#{pr_tag}&gt;</strong>
        <strong style="color: rgb(17, 138, 15);">&lt;#{status_tag}&gt;</strong>
      </div>
    }
  end

  def find_links(text)
    links = URI.extract(text)

    links.select { |link| link.start_with?('https://3.basecamp.com') }
  end

  def get_todo_resource(resource)
    todoset = todoset(project_id(resource))
    todolist = todolist((todoset),todolist_id(resource))
    todo = todo(todolist,todo_id(resource))
  end

  def project_id(resource)
    @client.project(resource['bucket']['id'])
  end

  def todoset(project_id)
    @client.todoset(project_id)
  end  

  def todolist_id(resource)
    resource['parent']['id']
  end  

  def todolist(todoset,id)
    @client.todolist(todoset,id)
  end

  def todo_id(resource)
    resource['id']
  end

  def todo(todolist,id)
    @client.todo(todolist,id)
  end

end