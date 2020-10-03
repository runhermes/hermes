# frozen_string_literal: true

class Gitlab
  API = ENV['HM_GITLAB_API']
  TOKEN = ENV['HM_GITLAB_TOKEN']
  SECRET = ENV['HM_GITLAB_SECRET']

  def initialize
  end

  def valid?(request)
    return @request["object_kind"] == "merge_request"
  end

end