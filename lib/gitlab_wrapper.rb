# frozen_string_literal: true

class GitlabWrapper
  API = ENV['HM_GITLAB_API']
  TOKEN = ENV['HM_GITLAB_TOKEN']
  SECRET = ENV['HM_GITLAB_SECRET']

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
    case @request["state"]
    when "opened"
      PullRequestState::OPENED
    when "closed"
      PullRequestState::CLOSED
    when "reopened"
      PullRequestState::REOPENED
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

  def url
    @request["url"]
  end
end