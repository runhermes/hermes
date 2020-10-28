# frozen_string_literal: true

class MergeRequest
  API = ENV['HM_GITLAB_API']
  TOKEN = ENV['HM_GITLAB_TOKEN']
  SECRET = ENV['HM_GITLAB_SECRET']

  def initialize(logger, request)
    @logger = logger
    # puts "API: #{API}; Token: #{TOKEN}"

    @request = request
  end

  def valid?
    return @request["object_kind"] == "merge_request"
  end

  def status
    case @request['object_attributes']['action']
    when "open"
      PullRequestStatus::OPENED
    when "update"
      PullRequestStatus::UPDATED
    when "close"
      PullRequestStatus::CLOSED
    when "merge"
      PullRequestStatus::MERGED
    when "reopen"
      PullRequestStatus::REOPENED
    else
      raise Error::UnexpectedMergeRequestStatus, @request
    end
  end

  def state
    @request['object_attributes']['state'].capitalize
  end

  def description
    @request['object_attributes']['description']
  end

  def full_name
    "#{acronym} #{project_name}/#{id}"
  end

  def simple_name
    "#{acronym}##{id}"
  end

  def noun
    'merge request'
  end

  def acronym
    'MR'
  end

  def id
    @request['object_attributes']['iid']
  end

  def url
    @request["object_attributes"]["url"]
  end

  def project_name
    @request["project"]["name"]
  end

  def tags
    ["Proj:#{project_name}", "#{acronym}:#{id}"]
  end
end