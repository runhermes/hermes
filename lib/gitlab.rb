# frozen_string_literal: true

require_relative './basecamp_accessor.rb'


class Gitlab
  API = ENV['HM_GITLAB_API']
  TOKEN = ENV['HM_GITLAB_TOKEN']
  SECRET = ENV['HM_GITLAB_SECRET']

  def initialize(request)
    @request = request
  end

  def valid?
    return @request["object_kind"] == "merge_request"
  end

  def process_mr
    # TODO: Handle different MR states, open, close or update
    resources = BasecampAccessor.resources(@request["object_attributes"]["description"])

    return unless resources

    resources.each do |res|
      puts res.inspect
    end
  end

end