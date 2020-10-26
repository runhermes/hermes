# frozen_string_literal: true

class GitlabConnector
  # API = ENV['HM_GITLAB_API']
  # TOKEN = ENV['HM_GITLAB_TOKEN']
  # SECRET = ENV['HM_GITLAB_SECRET']

  def initialize(request)
    @client = Gitlab.client(
      endpoint: API,
      private_token: TOKEN
    )
    @request = request
  end

  def valid_request?
    return @request["object_kind"] == "merge_request"
  end

  def state
    case @request["object_attributes"]["state"]
    when "opened"
      PullRequestState::OPENED
    when "closed"
      PullRequestState::CLOSED
    when "merged"
      PullRequestState::MERGED
    else
      PullRequestState::UPDATED
    end
  end

  def noun
    'merge request'
  end

  def acronym
    'MR'
  end

  def id
    @request['object_attributes']['id']
  end

  def url
    @request["object_attributes"]["url"]
  end
end